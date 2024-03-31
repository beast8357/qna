class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]

  after_action :publish_answer, only: %i[create]

  def show
  end

  def new
  end

  def create
    @question = current_question
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    @answer = answer
    @answer.update(answer_params) if @answer.author == current_user
  end

  def destroy
    @answer = current_question.answers.find(params[:id])
    @answer.destroy if @answer.author == current_user
  end

  def best
    @answer = answer
    @answer.set_the_best if current_question.author == current_user
  end

  private

  helper_method :current_question, :answer

  def current_question
    @current_question ||= Question.with_attached_files.find(params[:question_id])
  end

  def answer
    params[:id] ? current_question.answers.with_attached_files.find(params[:id]) : current_question.answers.new
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers_channel_#{current_question.id}", broadcast_attributes)
  end

  def broadcast_attributes
    votes = {
      sum: @answer.votes_sum,
      like_url: helpers.custom_polymorphic_vote_path(@answer, action: :like),
      dislike_url: helpers.custom_polymorphic_vote_path(@answer, action: :dislike)
    }

    files = @answer.files.map { |file| { filename: file.filename.to_s, url: url_for(file) } }
    links = @answer.links.map { |link| { name: link.name, url: link.url } }

    {
      answer: @answer.attributes.merge(votes: votes, files: files, links: links),
      sid: session.id.public_id
    }
  end
end

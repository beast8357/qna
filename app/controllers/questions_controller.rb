class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.with_attached_files
  end

  def show
    @answer = question.answers.new
    @answer.links.build
    gon.push({
      question_id: @question.id,
      sid: session&.id&.public_id
    })
  end

  def new
    question.links.build
    question.reward = Reward.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    question.update(question_params) if question.author == current_user
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:id, :title, :image, :_destroy])
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast("questions_channel", {
      question: {
        title: question.title,
        url: url_for(question)
      }
    })
  end
end

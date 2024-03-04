class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

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
end

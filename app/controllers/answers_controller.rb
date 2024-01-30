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

  def destroy
    answer.destroy
    redirect_to question_path(current_question)
  end

  private

  helper_method :current_question, :answer

  def current_question
    @current_question ||= Question.find(params[:question_id])
  end

  def answer
    params[:id] ? current_question.answers.find(params[:id]) : current_question.answers.new
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end

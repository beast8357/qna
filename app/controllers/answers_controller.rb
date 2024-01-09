class AnswersController < ApplicationController
  helper_method :current_question, :answer

  def show
  end

  def new
  end

  private

  def current_question
    @current_question ||= Question.find(params[:question_id])
  end

  def answer
    current_question.answers.find(params[:id])
  end
end

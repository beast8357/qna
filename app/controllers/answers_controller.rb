class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  def show
  end

  def new
  end

  def create
    @answer = current_question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(current_question), notice: 'Your answer has been successfully created.'
    else
      redirect_to current_question, alert: "Body can't be blank."
    end
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

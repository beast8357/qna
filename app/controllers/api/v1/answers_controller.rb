# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = question.answers
    render json: @answers, each_serializer: AnswerSerializer
  end

  def show
    @answer = question.answers.find(params[:id])
    render json: @answer, serializer: AnswerSerializer
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end

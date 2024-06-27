# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: QuestionSerializer
  end
end

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.with_attached_files
  end

  def show
    @answer = question.answers.new
    @answer.links.build
  end

  def new
    question.links.build
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
                                     links_attributes: [:name, :url])
  end
end

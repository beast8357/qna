class AnswerSerializer < ActiveModel::Serializer
  include FilesList
  include LinksList

  attributes :id, :body, :created_at, :updated_at

  belongs_to :author, serializer: UserSerializer
  has_many :comments, each_serializer: CommentSerializer
end

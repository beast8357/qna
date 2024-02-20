class Question < ApplicationRecord
  has_many :answers, -> { sort_by_best }, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :title, :body, presence: true
end

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true

  validate :validate_attached_image

  private

  def validate_attached_image
    errors.add :image, 'must be present' unless image.attached?
    errors.add :image, 'has wrong format' if image.attached? && !image.content_type.starts_with?('image/')
  end
end

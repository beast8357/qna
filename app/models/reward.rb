class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true

  private

  def validate_attached_image
    errors.add :image, 'must be present' unless image.attached?
  end
end

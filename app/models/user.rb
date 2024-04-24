class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers,   foreign_key: 'author_id', dependent: :destroy
  has_many :rewards,   through: :answers,        dependent: :destroy
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def author_of?(subject)
    id == subject.author_id
  end
end

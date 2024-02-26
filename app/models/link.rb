class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  GIST_URL_FORMAT = /^https:\/\/gist\.github\.com\/(?<nickname>.+)\/(?<gist_id>[a-f\d]+)$/

  def gist?
    url.match(GIST_URL_FORMAT)
  end
end

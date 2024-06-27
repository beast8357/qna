module LinksList
  extend ActiveSupport::Concern

  included do
    attributes :links_list
  end

  def links_list
    object.links.map { |l| { name: l.name, url: l.url } }
  end
end

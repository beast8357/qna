require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:author) }

  it { should validate_presence_of(:commentable) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:body) }
end

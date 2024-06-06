require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :add_comment? do
    it 'grants access if the user exists' do
      expect(subject).to permit(User.new, build(:question))
    end

    it 'denies access if the user does not exist' do
      expect(subject).to_not permit(nil, build(:question))
    end
  end
end

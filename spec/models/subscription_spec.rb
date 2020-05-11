require 'rails_helper'

describe Subscription, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe 'Validation: uniqueness' do
    subject { create :subscription }
    it { should validate_uniqueness_of(:user).scoped_to(:question_id) }
  end
end

require 'rails_helper'

RSpec.describe User do

  describe 'relationships' do
    it { should have_many(:user_friends).dependent(:destroy) }
    it { should have_many(:friends).through(:user_friends) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_confirmation_of(:password) }
  end
end

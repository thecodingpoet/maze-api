require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('tom@example.com').for(:email) }
  it { should_not allow_value("test.com").for(:email) }
  it { should validate_presence_of(:avatar) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:birth_year) }
end

require 'rails_helper'

RSpec.describe Strength, type: :model do
  it { should belong_to(:user) }
end

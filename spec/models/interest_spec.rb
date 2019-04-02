require 'rails_helper'

RSpec.describe Interest, type: :model do
  it { should belong_to(:user) }
end

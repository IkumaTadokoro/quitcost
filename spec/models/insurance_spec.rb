# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Insurance, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:insurance)).to be_valid
  end

end

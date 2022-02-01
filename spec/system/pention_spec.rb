# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Insurance', type: :system, js: true do
  describe 'index' do
    scenario 'visiting the index' do
      visit pentions_path

      expect(page).to have_content '国民年金保険料一覧'
    end
  end
end

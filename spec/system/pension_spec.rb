# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pension', type: :system, js: true do
  describe 'index' do
    scenario 'visiting the index' do
      visit pensions_path

      expect(page).to have_content '国民年金保険料一覧'
    end
  end

  describe 'create' do
    let(:pension) { build(:pension) }
    scenario 'create a new record' do
      visit pensions_path
      click_link '新規登録'

      expect(page).to have_content '国民年金保険料登録'

      within 'form[name=pension]' do
        fill_in '年度', with: pension.year
        fill_in '保険料', with: pension.contribution
      end

      expect { click_button '登録' }.to change { Pension.count }.from(0).to(1)
      assert_current_path pensions_path
      assert_text '保険料率を保存しました。'
    end
  end

  describe 'update' do
    before { @pension = create(:pension, year: 2022, contribution: 16_540) }
    scenario 'update a existing record' do
      visit pensions_path
      click_link '国民年金保険料編集'

      expect(page).to have_content '国民年金保険料編集'

      fill_in '年度', with: 2023
      fill_in '保険料', with: 16_600

      click_button '更新'
      assert_current_path pensions_path
      assert_text '保険料率を更新しました。'
    end
  end

  describe 'destroy' do
    before { @pension = create(:pension) }
    scenario 'destroy a existing record' do
      visit pensions_path

      expect do
        all('tbody td')[1].click
        accept_confirm
        assert_text '保険料率を削除しました。'
        sleep(1)
      end
        .to change { Pension.count }.from(1).to(0)
    end
  end
end

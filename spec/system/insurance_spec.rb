# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Insurance', type: :system, js: true do
  describe 'index' do
    scenario 'visiting the index' do
      visit insurances_path

      expect(page).to have_content '国民健康保険料一覧'
    end
  end

  describe 'create' do
    let(:insurance_form) { build(:insurance_form, :all_months_are_target) }
    scenario 'create a new record' do
      visit insurances_path
      click_link '新規登録'

      expect(page).to have_content '国民健康保険料登録'

      fill_in '年度', with: insurance_form.year
      select JpLocalGov.find(insurance_form.local_gov_code).city, from: '市区町村名'
      fill_in '所得割（医療分）', with: insurance_form.medical_income_basis
      fill_in '資産割（医療分）', with: insurance_form.medical_asset_basis
      fill_in '均等割（医療分）', with: insurance_form.medical_capita_basis
      fill_in '平等割（医療分）', with: insurance_form.medical_household_basis
      fill_in '限度額（医療分）', with: insurance_form.medical_limit
      fill_in '所得割（後期高齢者支援分）', with: insurance_form.elderly_income_basis
      fill_in '資産割（後期高齢者支援分）', with: insurance_form.elderly_asset_basis
      fill_in '均等割（後期高齢者支援分）', with: insurance_form.elderly_capita_basis
      fill_in '平等割（後期高齢者支援分）', with: insurance_form.elderly_household_basis
      fill_in '限度額（後期高齢者支援分）', with: insurance_form.elderly_limit
      fill_in '所得割（介護分）', with: insurance_form.care_income_basis
      fill_in '資産割（介護分）', with: insurance_form.care_asset_basis
      fill_in '均等割（介護分）', with: insurance_form.care_capita_basis
      fill_in '平等割（介護分）', with: insurance_form.care_household_basis
      fill_in '限度額（介護分）', with: insurance_form.care_limit
      check '1月', allow_label_click: true
      check '2月', allow_label_click: true
      check '3月', allow_label_click: true
      check '4月', allow_label_click: true
      check '5月', allow_label_click: true
      check '6月', allow_label_click: true
      check '7月', allow_label_click: true
      check '8月', allow_label_click: true
      check '9月', allow_label_click: true
      check '10月', allow_label_click: true
      check '11月', allow_label_click: true
      check '12月', allow_label_click: true

      expect { click_button '登録' }
        .to change { Insurance.count }.from(0).to(1)
                                      .and change { PaymentTargetMonth.count }.from(0).to(12)
      assert_current_path insurances_path
      assert_text '保険料率を保存しました。'
    end
  end

  describe 'update' do
    before { @insurance = create(:insurance, :with_payment_target_month, month: 1) }
    scenario 'update a existing record' do
      # FIXME: 更新系のテストの補強
      visit insurances_path
      click_link '国民健康保険料編集'

      expect(page).to have_content '国民健康保険料編集'

      check '1月', allow_label_click: false
      check '2月', allow_label_click: true

      click_button '更新'
      assert_current_path insurances_path
      assert_text '保険料率を更新しました。'
    end
  end

  describe 'destroy' do
    before { @insurance = create(:insurance, :with_payment_target_month, month: 1) }
    scenario 'destroy a existing record' do
      visit insurances_path

      expect do
        all('tbody td')[1].click
        accept_confirm
        assert_text '保険料率を削除しました。'
        sleep(1)
      end
        .to change { Insurance.count }.from(1).to(0)
                                      .and change { PaymentTargetMonth.count }.from(1).to(0)
    end
  end
end

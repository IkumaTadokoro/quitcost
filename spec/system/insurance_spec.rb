# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Insurance', type: :system, js: true do
  let!(:user) { create(:user) }

  describe 'index' do
    scenario 'visiting the index before sign in' do
      visit admin_pensions_path
      assert_current_path new_user_session_path
      assert_text 'ログインもしくはアカウント登録してください。'
    end

    scenario 'visiting the index' do
      sign_in user
      visit admin_insurances_path

      expect(page).to have_content '国民健康保険料一覧'
    end
  end

  describe 'create' do
    context 'new record' do
      let(:insurance_form) { build(:insurance_form) }
      scenario 'create a new record' do
        sign_in user
        visit admin_insurances_path
        click_link '新規登録'

        expect(page).to have_content '国民健康保険料登録'

        within 'form[name=insurance]' do
          fill_in '年度', with: insurance_form.year
          first('.choices').click
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
          check 'insurance_month1'
          check 'insurance_month3'
          check 'insurance_month5'
          check 'insurance_month7'
          check 'insurance_month9'
          check 'insurance_month11'
        end

        expect { click_button '登録' }
          .to change { Insurance.count }.from(0).to(1)
                                        .and change { PaymentTargetMonth.count }.from(0).to(6)
        assert_current_path admin_insurances_path
        assert_text '保険料率を保存しました。'
      end
    end

    context 'copy record' do
      before { @insurance = create(:insurance, :with_payment_target_months, months: [1, 2, 3, 6, 7, 8, 9, 10, 11, 12], year: 2021, local_gov_code: '162019') }
      scenario 'copy and create a record' do
        sign_in user
        visit admin_insurances_path
        click_link '国民健康保険料複製'

        expect(page).to have_content '国民健康保険料登録'

        fill_in '年度', with: 2022

        expect { click_button '登録' }
          .to change { Insurance.count }.from(1).to(2)
                                        .and change { PaymentTargetMonth.count }.from(10).to(20)
        assert_current_path admin_insurances_path
        assert_text '保険料率を保存しました。'
      end
    end
  end

  describe 'update' do
    before { @insurance = create(:insurance, :with_payment_target_months, months: [1, 2], year: 2021, local_gov_code: '162019') }
    scenario 'update a existing record' do
      sign_in user
      visit admin_insurances_path
      click_link '国民健康保険料編集'

      expect(page).to have_content '国民健康保険料編集'

      within 'form[name=insurance]' do
        fill_in '所得割（医療分）', with: 7.2
        fill_in '資産割（医療分）', with: 0.5
        fill_in '均等割（医療分）', with: 10_000
        fill_in '平等割（医療分）', with: 30_000
        fill_in '限度額（医療分）', with: 20_000
        fill_in '所得割（後期高齢者支援分）', with: 2.94
        fill_in '資産割（後期高齢者支援分）', with: 0.0
        fill_in '均等割（後期高齢者支援分）', with: 6000
        fill_in '平等割（後期高齢者支援分）', with: 10_000
        fill_in '限度額（後期高齢者支援分）', with: 21_000
        fill_in '所得割（介護分）', with: 2.76
        fill_in '資産割（介護分）', with: 0
        fill_in '均等割（介護分）', with: 6728
        fill_in '平等割（介護分）', with: 7890
        fill_in '限度額（介護分）', with: 12_000
        uncheck 'insurance_month1'
        check 'insurance_month4'
        check 'insurance_month5'
        check 'insurance_month6'
        check 'insurance_month7'
        check 'insurance_month8'
        check 'insurance_month9'
        check 'insurance_month10'
        check 'insurance_month11'
        check 'insurance_month12'
      end

      click_button '更新'
      assert_current_path admin_insurances_path
      assert_text '保険料率を更新しました。'

      tds = page.all('td')
      expect(tds[3]).to have_content '2021'
      expect(tds[5]).to have_content '富山市'
      expect(tds[7]).to have_content '7.20'
      expect(tds[8]).to have_content '0.50'
      expect(tds[9]).to have_content '¥10,000'
      expect(tds[10]).to have_content '¥30,000'
      expect(tds[11]).to have_content '¥20,000'
      expect(tds[12]).to have_content '2.94'
      expect(tds[13]).to have_content '0.00'
      expect(tds[14]).to have_content '¥6,000'
      expect(tds[15]).to have_content '¥10,000'
      expect(tds[16]).to have_content '¥21,000'
      expect(tds[17]).to have_content '2.76'
      expect(tds[18]).to have_content '0.00'
      expect(tds[19]).to have_content '¥6,728'
      expect(tds[20]).to have_content '¥7,890'
      expect(tds[21]).to have_content '¥12,000'
      expect(tds[22]).to have_content '-'
      expect(tds[23]).to have_content '○'
      expect(tds[24]).to have_content '-'
      expect(tds[25]).to have_content '○'
      expect(tds[26]).to have_content '○'
      expect(tds[27]).to have_content '○'
      expect(tds[28]).to have_content '○'
      expect(tds[29]).to have_content '○'
      expect(tds[30]).to have_content '○'
      expect(tds[31]).to have_content '○'
      expect(tds[32]).to have_content '○'
      expect(tds[33]).to have_content '○'
    end
  end

  describe 'destroy' do
    before { @insurance = create(:insurance, :with_payment_target_months, months: [1]) }
    scenario 'destroy a existing record' do
      sign_in user
      visit admin_insurances_path

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

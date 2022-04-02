# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceForm, type: :model do
  describe '#validate' do
    describe ':year' do
      subject { insurance_form.errors[:year] }
      before { insurance_form.valid? }
      let(:insurance_form) { build(:insurance_form, year: year) }

      context 'when year is nil' do
        let(:year) { nil }
        it { is_expected.to include 'を入力してください' }
      end

      context 'when year is negative' do
        let(:year) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when year is 0' do
        let(:year) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when year is 1' do
        let(:year) { 1 }
        it { is_expected.to be_empty }
      end

      context 'when year is decimal' do
        let(:year) { 1.0 }
        it { is_expected.to be_empty }
      end

      context 'when year is string' do
        let(:year) { '２０００' }
        it { is_expected.to be_empty }
      end
    end

    describe ':local_gov_code' do
      subject { insurance_form.errors[:local_gov_code] }
      let(:insurance_form) { build(:insurance_form, params) }

      context 'when local_gov_code is nil' do
        let(:params) { { local_gov_code: nil } }
        before { insurance_form.valid? }
        it { is_expected.to include 'を入力してください' }
      end

      context 'when local_gov_code DOES NOT meet JIS Standard' do
        let(:params) { { local_gov_code: '131017' } }
        before { insurance_form.valid? }
        it { is_expected.to include 'に無効な値が設定されています' }
      end

      context 'when duplicate record is existing' do
        let(:params) { { year: 2000, local_gov_code: '131016' } }
        before do
          create(:insurance, year: 2000, local_gov_code: '131016')
          insurance_form.valid?
        end
        it { is_expected.to include 'に既に登録済みのコードが指定されています。年度を見直してください' }
      end
    end

    describe ':income_basis' do
      subject { insurance_form.errors[:medical_income_basis] }
      before { insurance_form.valid? }
      let(:insurance_form) { build(:insurance_form, medical_income_basis: medical_income_basis) }

      context 'when medical_income_basis is nil' do
        let(:medical_income_basis) { nil }
        it { is_expected.to be_empty }
      end

      context 'when medical_income_basis is less than 0' do
        let(:medical_income_basis) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when medical_income_basis is 0' do
        let(:medical_income_basis) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when medical_income_basis is 0 ~ 100' do
        let(:medical_income_basis) { 50.05 }
        it { is_expected.to be_empty }
      end

      context 'when medical_income_basis is 99' do
        let(:medical_income_basis) { 99 }
        it { is_expected.to be_empty }
      end

      context 'when medical_income_basis is 100' do
        let(:medical_income_basis) { 100 }
        it { is_expected.to be_empty }
      end

      context 'when medical_income_basis is greater than 100' do
        let(:medical_income_basis) { 101 }
        it { is_expected.to include 'は100以下の値にしてください' }
      end
    end

    describe ':asset_basis' do
      subject { insurance_form.errors[:medical_asset_basis] }
      before { insurance_form.valid? }
      let(:insurance_form) { build(:insurance_form, medical_asset_basis: medical_asset_basis) }

      context 'when medical_asset_basis is nil' do
        let(:medical_asset_basis) { nil }
        it { is_expected.to be_empty }
      end

      context 'when medical_asset_basis is less than 0' do
        let(:medical_asset_basis) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when medical_asset_basis is 0' do
        let(:medical_asset_basis) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when medical_asset_basis is 0 ~ 100' do
        let(:medical_asset_basis) { 50.05 }
        it { is_expected.to be_empty }
      end

      context 'when medical_asset_basis is 99' do
        let(:medical_asset_basis) { 99 }
        it { is_expected.to be_empty }
      end

      context 'when medical_asset_basis is 100' do
        let(:medical_asset_basis) { 100 }
        it { is_expected.to be_empty }
      end

      context 'when medical_asset_basis is greater than 100' do
        let(:medical_asset_basis) { 101 }
        it { is_expected.to include 'は100以下の値にしてください' }
      end
    end

    describe ':capita_basis' do
      subject { insurance_form.errors[:medical_capita_basis] }
      before { insurance_form.valid? }
      let(:insurance_form) { build(:insurance_form, medical_capita_basis: medical_capita_basis) }

      context 'when medical_capita_basis is nil' do
        let(:medical_capita_basis) { nil }
        it { is_expected.to be_empty }
      end

      context 'when medical_capita_basis is less than 0' do
        let(:medical_capita_basis) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when medical_capita_basis is 0' do
        let(:medical_capita_basis) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when medical_capita_basis is over 0' do
        let(:medical_capita_basis) { 1 }
        it { is_expected.to be_empty }
      end
    end

    describe ':household_basis' do
      subject { insurance_form.errors[:medical_household_basis] }
      before { insurance_form.valid? }
      let(:insurance_form) { build(:insurance_form, medical_household_basis: medical_household_basis) }

      context 'when medical_household_basis is nil' do
        let(:medical_household_basis) { nil }
        it { is_expected.to be_empty }
      end

      context 'when medical_household_basis is less than 0' do
        let(:medical_household_basis) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when medical_household_basis is 0' do
        let(:medical_household_basis) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when medical_household_basis is over 0' do
        let(:medical_household_basis) { 1 }
        it { is_expected.to be_empty }
      end
    end

    describe 'payment_target_months' do
      subject { insurance_form.errors[:payment_target_months] }
      before { insurance_form.valid? }

      context 'when payment_target_months are checked' do
        let(:insurance_form) { build(:insurance_form, month1: true) }
        it { is_expected.to be_empty }
      end

      context 'when payment_target_months are NOT checked' do
        let(:insurance_form) { build(:insurance_form) }
        it { is_expected.to include '納付対象月は最低1つチェックしてください' }
      end
    end
  end

  describe '#save' do
    subject { insurance_form.save }

    context 'when params are valid' do
      context 'when success to save' do
        let!(:insurance_form) { build(:insurance_form, :all_months_are_target) }

        def find_payment_target_month(month)
          payment_target_months = Insurance.find_by(year: insurance_form.year, local_gov_code: insurance_form.local_gov_code).payment_target_months
          payment_target_months.find do |target_month|
            target_month.month.month == PaymentTargetMonth::CALENDAR[month]
          end
        end

        it { expect { subject }.to change { Insurance.count }.from(0).to(1) }
        it { expect { subject }.to change { PaymentTargetMonth.count }.from(0).to(12) }
        it 'saves January to March as the following year' do
          insurance_form.save
          expect(find_payment_target_month(:january).month.year).to eq insurance_form.year.next
          expect(find_payment_target_month(:february).month.year).to eq insurance_form.year.next
          expect(find_payment_target_month(:march).month.year).to eq insurance_form.year.next
        end

        it 'saves April to December as the this year' do
          insurance_form.save
          expect(find_payment_target_month(:april).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:may).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:june).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:july).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:august).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:september).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:october).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:november).month.year).to eq insurance_form.year
          expect(find_payment_target_month(:december).month.year).to eq insurance_form.year
        end
      end

      context 'when failed to save' do
        let!(:insurance_form) { build(:insurance_form, :all_months_are_target) }
        context 'when insurance record is invalid' do
          before { allow(insurance_form).to receive(:update_insurance!).and_raise(ActiveRecord::RecordInvalid) }
          it { is_expected.to be_falsey }
        end

        context 'when payment_target_months record is invalid' do
          before { allow(insurance_form).to receive(:update_payment_target_months!).and_raise(ActiveRecord::RecordInvalid) }
          it { is_expected.to be_falsey }
        end
      end
    end

    context 'when params are INVALID' do
      let(:insurance_form) { build(:insurance_form, year: nil) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#to_model' do
    subject { insurance_form.to_model == insurance_form.insurance }
    let(:insurance_form) { build(:insurance_form) }
    it { is_expected.to be_truthy }
  end

  describe '.calendars' do
    subject { InsuranceForm.calendars }
    let!(:expected) { %w[month1 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12] }
    it { is_expected.to eq expected }
  end
end

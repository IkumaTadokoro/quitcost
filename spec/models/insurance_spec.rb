# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Insurance, type: :model do
  describe 'month_name_is_target?' do
    let!(:insurance_pay_only_december) { create(:insurance, :with_payment_target_months, months: [12]) }

    context 'when insurance has specified month as a payment target' do
      it 'returns true' do
        expect(insurance_pay_only_december.payment_target_months.december_is_target?).to be_truthy
      end
    end

    context 'when specified month is NOT payment target' do
      it 'returns false' do
        expect(insurance_pay_only_december.payment_target_months.january_is_target?).to be_falsey
      end
    end
  end

  describe '.rate' do
    subject { Insurance.rate(year: 2022, local_gov_code: '012033') }

    context 'when Insurance for specified year and local government is exist' do
      before { create(:insurance, year: 2022, local_gov_code: '012033') }
      it 'returns Insurance record, `year` is specified year and `local_gov_code` is specified code' do
        expect(subject.year).to eq 2022
        expect(subject.local_gov_code).to eq '012033'
      end
    end

    context 'when Insurance for specified year and local government is NOT exist' do
      context 'when Insurance for specified local government and other year is exist' do
        before { create(:insurance, year: 2021, local_gov_code: '012033') }
        it 'returns Insurance record, `year` is other year and `local_gov_code` is specified code' do
          expect(subject.year).to eq 2021
          expect(subject.local_gov_code).to eq '012033'
        end
      end

      context 'when Insurance for specified local government is NOT exist' do
        context 'when Insurance for specified year and prefecture capital of specified local government is exist' do
          before { create(:insurance, year: 2022, local_gov_code: '011002') }
          it 'returns Insurance record, `year` is specified year and `local_gov_code` is prefecture capital' do
            expect(subject.year).to eq 2022
            expect(subject.local_gov_code).to eq '011002'
          end
        end

        context 'when Insurance for specified year and prefecture capital of specified local government is NOT exist' do
          before { create(:insurance, year: 2021, local_gov_code: '011002') }
          it 'returns Insurance record, `year` is other year and `local_gov_code` is prefecture capital' do
            expect(subject.year).to eq 2021
            expect(subject.local_gov_code).to eq '011002'
          end
        end
      end
    end
  end
end

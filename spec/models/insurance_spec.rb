# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Insurance, type: :model do
  describe '#{month_name}_is_target?' do
    let!(:insurance_pay_only_december) { create(:insurance, :with_payment_target_month, month: 12) }

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
end

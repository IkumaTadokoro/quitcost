# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LocalTaxLaw' do
  describe '.calc_tax_base' do
    subject { LocalTaxLaw.calc_tax_base { 9999 } }
    it { is_expected.to eq 9000 }
  end

  describe '.calc_determined_amount' do
    subject { LocalTaxLaw.calc_determined_amount { 9999 } }
    it { is_expected.to eq 9900 }
  end

  describe 'calc_installments' do
    context 'when any flags are NOT given' do
      subject { LocalTaxLaw.calc_installments(600_000, [6, 7, 8, 9, 10, 11, 12]) }
      context 'when dues size is positive' do
        it "summarises the fraction of each month's fee of less than ¥1,000 the first month" do
          expect(subject).to eq [90_000, 85_000, 85_000, 85_000, 85_000, 85_000, 85_000]
          expect(subject.sum).to eq 600_000
        end
      end
    end

    context 'when flags are given' do
      subject do
        LocalTaxLaw.calc_installments(600_000, [6, 7, 8, 9, 10, 11, 12], municipal_ordinance: municipal_ordinance, special_insurance: special_insurance)
      end

      context 'when municipal_ordinance is given' do
        let!(:municipal_ordinance) { true }
        let!(:special_insurance) { false }
        it 'returns fee rounded down 100 yen except for first-month' do
          expect(subject).to eq [85_800, 85_700, 85_700, 85_700, 85_700, 85_700, 85_700]
          expect(subject.sum).to eq 600_000
        end
      end

      context 'when special_insurance is given' do
        let!(:municipal_ordinance) { false }
        let!(:special_insurance) { true }
        it 'returns fee rounded down 100 yen except for first-month' do
          expect(subject).to eq [85_800, 85_700, 85_700, 85_700, 85_700, 85_700, 85_700]
          expect(subject.sum).to eq 600_000
        end
      end

      context 'when municipal_ordinance and special_insurance are given' do
        let!(:municipal_ordinance) { true }
        let!(:special_insurance) { true }
        it 'returns fee rounded down 100 yen except for first-month' do
          expect(subject).to eq [85_800, 85_700, 85_700, 85_700, 85_700, 85_700, 85_700]
          expect(subject.sum).to eq 600_000
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Salary, type: :model do
  # https://www.nta.go.jp/taxes/shiraberu/shinkoku/tebiki/2021/b/03/order2/3-2_06.htm
  describe '.calc' do
    subject { Simulation::Salary.calc(income) }

    context 'whole_income less than 551_000' do # 0
      let!(:income) { 550_999 }
      it { is_expected.to eq 0 }
    end

    context 'whole_income less than 1_619_000' do # income - 550,000
      context 'whole_income equal to 551_000' do
        let!(:income) { 551_000 }
        it { is_expected.to eq 1_000 }
      end

      context 'whole_income equal to 1_618_999' do
        let!(:income) { 1_618_999 }
        it { is_expected.to eq 1_068_999 }
      end
    end

    context 'whole_income less than 1_620_000' do # 1,069,000
      context 'whole_income equal to 1_619_000' do
        let!(:income) { 1_619_000 }
        it { is_expected.to eq 1_069_000 }
      end

      context 'whole_income equal to 1_619_999' do
        let!(:income) { 1_619_999 }
        it { is_expected.to eq 1_069_000 }
      end
    end

    context 'whole_income less than 1_622_000' do # 1,070,000
      context 'whole_income equal to 1_620_000' do
        let!(:income) { 1_620_000 }
        it { is_expected.to eq 1_070_000 }
      end

      context 'whole_income equal to 1_621_999' do
        let!(:income) { 1_621_999 }
        it { is_expected.to eq 1_070_000 }
      end
    end

    context 'whole_income < 1_624_000' do # 1,072,000
      context 'whole_income equal to 1_622_000' do
        let!(:income) { 1_622_000 }
        it { is_expected.to eq 1_072_000 }
      end

      context 'whole_income equal to 1_623_999' do
        let!(:income) { 1_623_999 }
        it { is_expected.to eq 1_072_000 }
      end
    end

    context 'whole_income < 1_628_000' do # 1,074,000
      context 'whole_income equal to 1_624_000' do
        let!(:income) { 1_624_000 }
        it { is_expected.to eq 1_074_000 }
      end

      context 'whole_income equal to 1_627_999' do
        let!(:income) { 1_627_999 }
        it { is_expected.to eq 1_074_000 }
      end
    end

    context 'whole_income < 1_800_000' do # (income / 4) * 2.4  + 100,000（Rounded down to the nearest 1000 yen）
      context 'whole_income equal to 1_628_000' do
        let!(:income) { 1_628_000 }
        it { is_expected.to eq 1_076_800 }
      end

      context 'whole_income equal to 1_799_999' do
        let!(:income) { 1_799_999 }
        it { is_expected.to eq 1_177_600 }
      end
    end

    context 'whole_income < 3_600_000' do # (income / 4) * 2.8  - 80,000（Rounded down to the nearest 1000 yen）
      context 'whole_income equal to 1_800_000' do
        let!(:income) { 1_800_000 }
        it { is_expected.to eq 1_180_000 }
      end

      context 'whole_income equal to 3_599_999' do
        let!(:income) { 3_599_999 }
        it { is_expected.to eq 2_437_200 }
      end
    end

    context 'whole_income < 6_600_000' do # (income / 4) * 3.2  - 440,000（Rounded down to the nearest 1000 yen）
      context 'whole_income equal to 3_600_000' do
        let!(:income) { 3_600_000 }
        it { is_expected.to eq 2_440_000 }
      end

      context 'whole_income equal to 6_599_999' do
        let!(:income) { 6_599_999 }
        it { is_expected.to eq 4_836_800 }
      end
    end

    context 'whole_income < 8_500_000' do # income * 0.9 - 1,100,000
      context 'whole_income equal to 6_600_000' do
        let!(:income) { 6_600_000 }
        it { is_expected.to eq 4_840_000 }
      end

      context 'whole_income equal to 8_499_999' do
        let!(:income) { 8_499_999 }
        it { is_expected.to eq 6_549_999 }
      end
    end

    context 'whole_income >= 8_500_000' do # income - 1,950,000
      context 'whole_income equal to 8_500_000' do
        let!(:income) { 8_500_000 }
        it { is_expected.to eq 6_550_000 }
      end

      context 'whole_income over 8_500_000' do
        let!(:income) { 8_500_001 }
        it { is_expected.to eq 6_550_001 }
      end
    end
  end
end

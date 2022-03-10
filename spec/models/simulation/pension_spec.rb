# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Pension, type: :model do
  describe '.calc' do
    subject { Simulation::Pension.calc(param_parser) }
    let(:param_parser) { double('ParamParser', retirement_month: from, employment_month: to) }

    context 'when Pension record for the specified year is exist' do
      before do
        create(:pension, year: 2021, contribution: 16_610)
        create(:pension, year: 2022, contribution: 16_590)
      end

      context 'when the calculation period crosses fiscal year' do
        let!(:from) { Time.zone.parse('2022-03-01') }
        let!(:to) { Time.zone.parse('2022-05-01') }
        expected = [
          { month: Time.zone.parse('2022-03-01'), pension: 16_610 },
          { month: Time.zone.parse('2022-04-01'), pension: 16_590 }
        ]
        it { is_expected.to eq expected }
      end

      context 'when the calculation period DOES NOT cross fiscal year' do
        context 'when the calculation period is 1' do
          let!(:from) { Time.zone.parse('2021-04-01') }
          let!(:to) { Time.zone.parse('2021-06-01') }
          expected = [
            { month: Time.zone.parse('2021-04-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-05-01'), pension: 16_610 }
          ]
          it { is_expected.to eq expected }
        end

        context 'when the calculation period is 12' do
          let!(:from) { Time.zone.parse('2021-04-01') }
          let!(:to) { Time.zone.parse('2022-04-01') }
          expected = [
            { month: Time.zone.parse('2021-04-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-05-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-06-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-07-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-08-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-09-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-10-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-11-01'), pension: 16_610 },
            { month: Time.zone.parse('2021-12-01'), pension: 16_610 },
            { month: Time.zone.parse('2022-01-01'), pension: 16_610 },
            { month: Time.zone.parse('2022-02-01'), pension: 16_610 },
            { month: Time.zone.parse('2022-03-01'), pension: 16_610 }
          ]
          it { is_expected.to eq expected }
        end
      end
    end

    context 'when Pension record for the specified year is NOT exist' do
      before { create(:pension, year: 2021, contribution: 16_610) }

      context 'when record exists for a year before the specified year' do
        let!(:from) { Time.zone.parse('2022-04-01') }
        let!(:to) { Time.zone.parse('2022-06-01') }
        expected = [
          { month: Time.zone.parse('2022-04-01'), pension: 16_610 },
          { month: Time.zone.parse('2022-05-01'), pension: 16_610 }
        ]
        it { is_expected.to eq expected }
      end

      context 'when record DOES NOT exists for a year before the specified year' do
        let!(:from) { Time.zone.parse('2023-04-01') }
        let!(:to) { Time.zone.parse('2023-06-01') }
        expected = [
          { month: Time.zone.parse('2023-04-01'), pension: 16_610 },
          { month: Time.zone.parse('2023-05-01'), pension: 16_610 }
        ]
        it { is_expected.to eq expected }
      end
    end
  end
end

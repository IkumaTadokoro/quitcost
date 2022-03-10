# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Simulation::ParamParser' do
  describe '#salary_table' do
    subject { Simulation::ParamParser.new(params).salary_table }
    let!(:params) do
      {
        retirement_month: '2022-06-01',
        employment_month: '2022-12-01',
        age: '20',
        prefecture: '東京都',
        city: '千代田区',
        simulation_date: simulation_date,
        previous_salary: '5000000',
        salary: '5500000',
        scheduled_salary: '5800000',
        previous_social_insurance: '730000',
        social_insurance: '825000',
        scheduled_social_insurance: '870000'
      }
    end

    context 'when simulation_date is March' do
      let!(:simulation_date) { '2022-03-01' }
      it { is_expected.to eq({ 2020 => 5_000_000, 2021 => 5_500_000, 2022 => 5_800_000 }) }
    end

    context 'when simulation_date is April' do
      let!(:simulation_date) { '2022-04-01' }
      it { is_expected.to eq({ 2021 => 5_000_000, 2022 => 5_500_000, 2023 => 5_800_000 }) }
    end
  end

  describe '#social_insurance_table' do
    subject { Simulation::ParamParser.new(params).social_insurance_table }
    let!(:params) do
      {
        retirement_month: '2022-06-01',
        employment_month: '2022-12-01',
        age: '20',
        prefecture: '東京都',
        city: '千代田区',
        simulation_date: simulation_date,
        previous_salary: '5000000',
        salary: '5500000',
        scheduled_salary: '5800000',
        previous_social_insurance: '730000',
        social_insurance: '825000',
        scheduled_social_insurance: '870000'
      }
    end

    context 'when simulation_date is March' do
      let!(:simulation_date) { '2022-03-01' }
      it { is_expected.to eq({ 2020 => 730_000, 2021 => 825_000, 2022 => 870_000 }) }
    end

    context 'when simulation_date is April' do
      let!(:simulation_date) { '2022-04-01' }
      it { is_expected.to eq({ 2021 => 730_000, 2022 => 825_000, 2023 => 870_000 }) }
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequiredSalaryAndSocialInsuranceValidator, type: :model do
  describe '#validate' do
    before { mock.valid? }
    subject { mock }

    let!(:mock) do
      record = %i[simulation_date retirement_month employment_month previous_salary previous_social_insurance salary social_insurance scheduled_salary
                  scheduled_social_insurance]
      build_validator_mock(record: record).new(
        simulation_date: simulation_date,
        retirement_month: retirement_month,
        employment_month: employment_month,
        previous_salary: previous_salary,
        previous_social_insurance: previous_social_insurance,
        salary: salary,
        social_insurance: social_insurance,
        scheduled_salary: scheduled_salary,
        scheduled_social_insurance: scheduled_social_insurance
      )
    end

    context 'when retirement_month < Jun' do
      let!(:simulation_date) { Time.zone.parse('2022-04-01') }
      let!(:retirement_month) { Time.zone.parse('2022-05-01') }
      let!(:employment_month) { Time.zone.parse('2023-03-01') }
      let!(:salary) { 5_000_000 }
      let!(:social_insurance) { 750_000 }
      let!(:scheduled_salary) { 5_000_000 }
      let!(:scheduled_social_insurance) { 750_000 }

      context 'when previous_salary is nil' do
        let!(:previous_salary) { nil }
        let!(:previous_social_insurance) { 750_000 }
        it { is_expected.to be_invalid }
      end

      context 'when previous_social_insurance is nil' do
        let!(:previous_salary) { 5_000_000 }
        let!(:previous_social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are nil' do
        let!(:previous_salary) { nil }
        let!(:previous_social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are NOT nil' do
        let!(:previous_salary) { 5_000_000 }
        let!(:previous_social_insurance) { 750_000 }
        it { is_expected.to be_valid }
      end
    end

    context 'when retirement_month >= Jun && retirement_month < next Jun' do
      let!(:simulation_date) { Time.zone.parse('2022-06-01') }
      let!(:retirement_month) { Time.zone.parse('2022-12-01') }
      let!(:employment_month) { Time.zone.parse('2023-04-01') }
      let!(:previous_salary) { nil }
      let!(:previous_social_insurance) { nil }
      let!(:salary) { 5_000_000 }
      let!(:social_insurance) { 750_000 }

      context 'when previous_salary is nil' do
        let!(:scheduled_salary) { nil }
        let!(:scheduled_social_insurance) { 750_000 }
        it { is_expected.to be_invalid }
      end

      context 'when previous_social_insurance is nil' do
        let!(:scheduled_salary) { 5_000_000 }
        let!(:scheduled_social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are nil' do
        let!(:scheduled_salary) { nil }
        let!(:scheduled_social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are NOT nil' do
        let!(:scheduled_salary) { 5_000_000 }
        let!(:scheduled_social_insurance) { 750_000 }
        it { is_expected.to be_valid }
      end
    end

    context 'when employment_month >= next Apr' do
      let!(:simulation_date) { Time.zone.parse('2022-06-01') }
      let!(:retirement_month) { Time.zone.parse('2023-05-01') }
      let!(:employment_month) { Time.zone.parse('2023-06-01') }
      let!(:previous_salary) { nil }
      let!(:previous_social_insurance) { nil }
      let!(:scheduled_salary) { 5_000_000 }
      let!(:scheduled_social_insurance) { 750_000 }

      context 'when previous_salary is nil' do
        let!(:salary) { nil }
        let!(:social_insurance) { 750_000 }
        it { is_expected.to be_invalid }
      end

      context 'when previous_social_insurance is nil' do
        let!(:salary) { 5_000_000 }
        let!(:social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are nil' do
        let!(:salary) { nil }
        let!(:social_insurance) { nil }
        it { is_expected.to be_invalid }
      end

      context 'when previous_salary and previous_social_insurance are NOT nil' do
        let!(:salary) { 5_000_000 }
        let!(:social_insurance) { 750_000 }
        it { is_expected.to be_valid }
      end
    end
  end
end

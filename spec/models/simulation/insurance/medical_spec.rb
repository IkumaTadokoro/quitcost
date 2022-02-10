# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Insurance::Medical, type: :model do
  describe '.call' do
    subject { Simulation::Insurance::Medical.call(year: year, local_gov_code: local_gov_code, income: income, age: age) }
    let!(:year) { 2021 }
    let!(:local_gov_code) { '131016' }
    let!(:insurance) do
      create(
        :insurance,
        year: 2021,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 37_300,
        medical_household_basis: 12_700,
        medical_limit: 630_000
      )
    end

    context 'when age is less than 75' do
      let!(:age) { 74 }

      context 'when calculate result is less than medical limit' do
        let!(:income) { 10_379_993 }
        it { is_expected.to eq 629_999 }
      end

      context 'when calculate result is medical_limit' do
        let!(:income) { 10_380_000 }
        it { is_expected.to eq insurance.medical_limit }
      end

      context 'when calculation result is over medical_limit' do
        let!(:income) { 10_380_001 }
        it { is_expected.to eq insurance.medical_limit }
      end
    end

    context 'when age is 75 or more' do
      let!(:income) { 10_380_000 }
      context 'age is 75' do
        let!(:age) { 75 }
        it { is_expected.to eq 0 }
      end

      context 'when age is over 75' do
        let!(:age) { 76 }
        it { is_expected.to eq 0 }
      end
    end
  end
end

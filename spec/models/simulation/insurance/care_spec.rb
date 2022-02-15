# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Insurance::Care, type: :model do
  describe '.call' do
    subject { Simulation::Insurance::Care.call(year: year, local_gov_code: local_gov_code, income: income, age: age) }
    let!(:year) { 2021 }
    let!(:local_gov_code) { '131016' }
    let!(:insurance) do
      create(
        :insurance,
        year: 2021,
        local_gov_code: '131016',
        care_income_basis: 1.21,
        care_capita_basis: 14_200,
        care_household_basis: 10_600,
        care_limit: 170_000
      )
    end

    context 'when age is less than 40' do
      context 'when age is less than 40' do
        let!(:age) { 39 }
        let!(:income) { 14_380_000 }
        it { is_expected.to eq 0 }
      end
    end

    context 'when age is between 40 and 64' do
      context 'when age is 40' do
        let!(:age) { 40 }
        context 'when calculate result is less than care limit' do
          let!(:income) { 14_379_958 }
          it { is_expected.to eq 169_999 }
        end

        context 'when calculate result is care_limit' do
          let!(:income) { 14_380_000 }
          it { is_expected.to eq insurance.care_limit }
        end

        context 'when calculation result is over care_limit' do
          let!(:income) { 14_380_001 }
          it { is_expected.to eq insurance.care_limit }
        end
      end

      context 'when age is 64' do
        let!(:age) { 64 }
        context 'when calculate result is less than care limit' do
          let!(:income) { 14_379_958 }
          it { is_expected.to eq 169_999 }
        end

        context 'when calculate result is care_limit' do
          let!(:income) { 14_380_000 }
          it { is_expected.to eq insurance.care_limit }
        end

        context 'when calculation result is over care_limit' do
          let!(:income) { 14_380_001 }
          it { is_expected.to eq insurance.care_limit }
        end
      end
    end

    context 'when age is 65 or more' do
      let!(:income) { 14_380_000 }
      context 'age is 65' do
        let!(:age) { 65 }
        it { is_expected.to eq 0 }
      end

      context 'when age is over 65' do
        let!(:age) { 66 }
        it { is_expected.to eq 0 }
      end
    end
  end
end

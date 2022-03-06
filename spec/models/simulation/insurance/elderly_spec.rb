# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Insurance::Elderly, type: :model do
  describe '.call' do
    subject { Simulation::Insurance::Elderly.calc(year: year, local_gov_code: local_gov_code, income: income, age: age) }
    let!(:year) { 2021 }
    let!(:local_gov_code) { '131016' }
    let!(:insurance) do
      create(
        :insurance,
        year: 2021,
        local_gov_code: '131016',
        elderly_income_basis: 2.04,
        elderly_capita_basis: 11_000,
        elderly_household_basis: 5_600,
        elderly_limit: 190_000
      )
    end

    context 'when age is less than 75' do
      let!(:age) { 74 }

      context 'when calculate result is less than elderly limit' do
        let!(:income) { 10_879_975 }
        it { is_expected.to eq 189_999 }
      end

      context 'when calculate result is elderly_limit' do
        let!(:income) { 10_880_000 }
        it { is_expected.to eq insurance.elderly_limit }
      end

      context 'when calculation result is over elderly_limit' do
        let!(:income) { 10_880_001 }
        it { is_expected.to eq insurance.elderly_limit }
      end
    end

    context 'when age is 75 or more' do
      let!(:income) { 10_880_000 }
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

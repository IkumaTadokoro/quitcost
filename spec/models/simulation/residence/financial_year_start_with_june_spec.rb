# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Simulation::Residence::FinancialYearStartWithJune', type: :model do
  using Simulation::Residence::FinancialYearStartWithJune

  describe '#beginning_of_residence_fy' do
    subject { time.beginning_of_residence_fy }
    let!(:time) { Time.zone.parse("2022-#{month}-01") }

    context 'when month is January' do
      let!(:month) { '1' }
      it { is_expected.to eq Time.zone.parse('2021-06-01') }
    end

    context 'when month is March' do
      let!(:month) { '3' }
      it { is_expected.to eq Time.zone.parse('2021-06-01') }
    end

    context 'when month is April' do
      let!(:month) { '4' }
      it { is_expected.to eq Time.zone.parse('2021-06-01') }
    end

    context 'when month is May' do
      let!(:month) { '5' }
      it { is_expected.to eq Time.zone.parse('2021-06-01') }
    end

    context 'when month is June' do
      let!(:month) { '6' }
      it { is_expected.to eq Time.zone.parse('2022-06-01') }
    end

    context 'when month is December' do
      let!(:month) { '12' }
      it { is_expected.to eq Time.zone.parse('2022-06-01') }
    end
  end

  describe '#residence_financial_year' do
    subject { time.residence_financial_year }
    let!(:time) { Time.zone.parse("2022-#{month}-01") }

    context 'when month is January' do
      let!(:month) { '1' }
      it { is_expected.to eq 2021 }
    end

    context 'when month is March' do
      let!(:month) { '3' }
      it { is_expected.to eq 2021 }
    end

    context 'when month is April' do
      let!(:month) { '4' }
      it { is_expected.to eq 2021 }
    end

    context 'when month is May' do
      let!(:month) { '5' }
      it { is_expected.to eq 2021 }
    end

    context 'when month is June' do
      let!(:month) { '6' }
      it { is_expected.to eq 2022 }
    end

    context 'when month is December' do
      let!(:month) { '12' }
      it { is_expected.to eq 2022 }
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MonthIterable' do
  describe '#months_between' do
    include MonthIterable
    subject { months_between(from: from, to: to) }

    context 'when valid parameters are given' do
      context 'when the start month > end month' do
        let!(:from) { Time.zone.parse('2022-04-01') }
        let!(:to) { Time.zone.parse('2023-04-01') }
        it 'returns each month from the start month to 1 month before the end month' do
          months = [
            Time.zone.parse('2022-04-01'),
            Time.zone.parse('2022-05-01'),
            Time.zone.parse('2022-06-01'),
            Time.zone.parse('2022-07-01'),
            Time.zone.parse('2022-08-01'),
            Time.zone.parse('2022-09-01'),
            Time.zone.parse('2022-10-01'),
            Time.zone.parse('2022-11-01'),
            Time.zone.parse('2022-12-01'),
            Time.zone.parse('2023-01-01'),
            Time.zone.parse('2023-02-01'),
            Time.zone.parse('2023-03-01')
          ]
          expect(subject).to eq months
        end
      end

      context 'when the start month = end month' do
        let!(:from) { Time.zone.parse('2022-04-01') }
        let!(:to) { Time.zone.parse('2022-04-01') }
        it { is_expected.to eq [] }
      end

      context 'when the start month < end month' do
        let!(:from) { Time.zone.parse('2023-04-01') }
        let!(:to) { Time.zone.parse('2022-04-01') }
        it { is_expected.to eq [] }
      end
    end
  end
end

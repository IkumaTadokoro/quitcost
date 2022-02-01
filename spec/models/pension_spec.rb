# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pension, type: :model do
  describe '#validate' do
    describe ':year' do
      subject { pension.errors[:year] }
      before { pension.valid? }
      let(:pension) { build(:pension, year: year) }

      context 'when year is nil' do
        let(:year) { nil }
        it { is_expected.to include 'を入力してください' }
      end

      context 'when year is negative' do
        let(:year) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when year is 0' do
        let(:year) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when year is 1' do
        let(:year) { 1 }
        it { is_expected.to be_empty }
      end

      context 'when year is decimal' do
        let(:year) { 1.0 }
        it { is_expected.to include 'は整数で入力してください' }
      end

      context 'when year is string' do
        let(:year) { '２０００' }
        it { is_expected.to include 'は数値で入力してください' }
      end
    end

    describe ':contribution' do
      subject { pension.errors[:contribution] }
      before { pension.valid? }
      let(:pension) { build(:pension, contribution: contribution) }

      context 'when contribution is nil' do
        let(:contribution) { nil }
        it { is_expected.to include 'を入力してください' }
      end

      context 'when contribution is negative' do
        let(:contribution) { -1 }
        it { is_expected.to include 'は0以上の値にしてください' }
      end

      context 'when contribution is 0' do
        let(:contribution) { 0 }
        it { is_expected.to be_empty }
      end

      context 'when contribution is 1' do
        let(:contribution) { 1 }
        it { is_expected.to be_empty }
      end

      context 'when contribution is decimal' do
        let(:contribution) { 1.0 }
        it { is_expected.to include 'は整数で入力してください' }
      end

      context 'when contribution is string' do
        let(:contribution) { '２０００' }
        it { is_expected.to include 'は数値で入力してください' }
      end
    end
  end
end

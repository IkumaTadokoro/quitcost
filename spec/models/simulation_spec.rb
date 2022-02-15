# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation, type: :model do
  describe 'grand_total' do
    it 'returns correct value' do
      sub_total = { insurance: 24_000, pension: 33_220, residence: 20_000 }

      allow_any_instance_of(Simulation).to receive(:sub_total).and_return(sub_total)

      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          local_gov_code: '131016',
          age: '40',
          simulation_date: '2022-02-11',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.grand_total).to eq 77_220
    end
  end

  describe 'sub_total' do
    it 'returns correct value' do
      monthly_payment = [
        { month: Time.zone.parse('2022/03/01'), fee: { insurance: 12_000, pension: 16_610, residence: 10_000 } },
        { month: Time.zone.parse('2022/04/01'), fee: { insurance: 12_000, pension: 16_610, residence: 10_000 } }
      ]
      allow_any_instance_of(Simulation).to receive(:monthly_payment).and_return(monthly_payment)

      expected = { insurance: 24_000, pension: 33_220, residence: 20_000 }
      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          local_gov_code: '131016',
          age: '40',
          simulation_date: '2022-02-11',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.sub_total).to eq expected
    end
  end

  describe '#monthly_payment' do
    it 'returns correct value' do
      insurance_mock = [{ month: Time.zone.parse('2022/03/01'), insurance: 301 }, { month: Time.zone.parse('2022/04/01'), insurance: 401 }]
      pension_mock = [{ month: Time.zone.parse('2022/03/01'), pension: 302 }, { month: Time.zone.parse('2022/04/01'), pension: 402 }]
      residence_mock = [{ month: Time.zone.parse('2022/03/01'), residence: 303 }, { month: Time.zone.parse('2022/04/01'), residence: 403 }]

      allow_any_instance_of(Simulation).to receive(:insurance).and_return(insurance_mock)
      allow_any_instance_of(Simulation).to receive(:pension).and_return(pension_mock)
      allow_any_instance_of(Simulation).to receive(:residence).and_return(residence_mock)

      expected = [
        { month: Time.zone.parse('2022/03/01'), fee: { insurance: 301, pension: 302, residence: 303 } },
        { month: Time.zone.parse('2022/04/01'), fee: { insurance: 401, pension: 402, residence: 403 } }
      ]
      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          local_gov_code: '131016',
          age: '40',
          simulation_date: '2022-02-11',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.monthly_payment).to eq expected
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Residence, type: :model do
  describe '.calc' do
    subject { Simulation::Residence.calc(parameter) }
    let(:parameter) do
      Simulation::Parameter.new(
        {
          retirement_month: retirement_month,
          employment_month: employment_month,
          prefecture: '東京都',
          city: '千代田区',
          age: 40,
          simulation_date: simulation_date,
          previous_salary: previous_salary,
          salary: salary,
          scheduled_salary: scheduled_salary,
          previous_social_insurance: '736489',
          social_insurance: '736489',
          scheduled_social_insurance: '500_000'
        }
      )
    end

    context 'salary > 1,000,000' do
      let!(:previous_salary) { 4_988_682 }
      let!(:salary) { 4_988_682 }
      let!(:scheduled_salary) { 3_000_000 }
      context 'when retiring in the year of the current date and be unemployed until the end of that year' do
        context 'retire between Jan and Mar' do
          let!(:simulation_date) { '2022-02-01' }
          let!(:retirement_month) { '2022-02-01' }
          let!(:employment_month) { '2022-06-01' }

          it 'invoices the special for Jan to May of the year in the month of retirement at once' do
            expected = [
              { month: Time.zone.parse('2022-02-01'), residence: 80_000 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire between Apr and May' do
          let!(:simulation_date) { '2022-04-01' }
          let!(:retirement_month) { '2022-04-01' }
          let!(:employment_month) { '2022-06-01' }

          it 'invoices the special for retirement month ~ May of the year in the month of retirement at once' do
            expected = [
              { month: Time.zone.parse('2022-04-01'), residence: 40_000 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire at the first period (Jun)' do
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2022-06-01' }
          let!(:retirement_month) { '2021-06-01' }

          it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
              { month: Time.zone.parse('2021-07-01'), residence: 0 },
              { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 60_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 60_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the second period (Aug)' do
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2022-06-01' }
          let!(:retirement_month) { '2021-07-01' }

          it 'invoices special for retirement month ~ May in instalments in Aug, Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2021-07-01'), residence: 0 },
              { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 73_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 73_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the third period (Oct)' do
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2022-06-01' }
          let!(:retirement_month) { '2021-09-01' }

          it 'invoices special for retirement month ~ May in instalments in Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 90_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 90_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the fourth period (Jan)' do
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2022-06-01' }
          let!(:retirement_month) { '2021-12-01' }

          it 'invoices special for retirement month ~ May in Jan at once' do
            expected = [
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 120_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end
      end

      context 'when retiring in the year of the current date and be unemployed until the end of NEXT year' do
        # 翌年度は国民健康保険料の都合上、3月分までしか表示できない（=翌々年度の4月に就職が制限）。
        context 'retire between Jan and May' do
          let!(:simulation_date) { '2022-02-01' }
          let!(:retirement_month) { '2022-02-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices the special for Jan to May of the year in the month of retirement at once, and next year is ordinary ' do
            expected = [
              { month: Time.zone.parse('2022-02-01'), residence: 80_000 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 },
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire at the first period (Jun)' do
          let!(:retirement_month) { '2021-06-01' }
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan, and next year is ordinary' do
            expected = [
              { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
              { month: Time.zone.parse('2021-07-01'), residence: 0 },
              { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 60_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 60_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 },
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the second period (Aug)' do
          let!(:retirement_month) { '2021-07-01' }
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments inAug, Oct, Jan, and next year is ordinary' do
            expected = [
              { month: Time.zone.parse('2021-07-01'), residence: 0 },
              { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 73_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 73_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 },
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the third period (Oct)' do
          let!(:retirement_month) { '2021-09-01' }
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Oct, Jan, and next year is ordinary' do
            expected = [
              { month: Time.zone.parse('2021-09-01'), residence: 0 },
              { month: Time.zone.parse('2021-10-01'), residence: 90_000 },
              { month: Time.zone.parse('2021-11-01'), residence: 0 },
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 90_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 },
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the fourth period (Jan)' do
          let!(:retirement_month) { '2021-12-01' }
          let!(:simulation_date) { '2021-06-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Jun at once, and next year is ordinary' do
            expected = [
              { month: Time.zone.parse('2021-12-01'), residence: 0 },
              { month: Time.zone.parse('2022-01-01'), residence: 120_000 },
              { month: Time.zone.parse('2022-02-01'), residence: 0 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 },
              { month: Time.zone.parse('2022-04-01'), residence: 0 },
              { month: Time.zone.parse('2022-05-01'), residence: 0 },
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end
      end

      context 'when retiring in the NEXT year of the current date and be unemployed until the end of year' do
        let!(:simulation_date) { '2021-06-01' }

        context 'retire between Jan and May' do
          let!(:retirement_month) { '2023-02-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices the special for Jan to May of the year in the month of retirement at once' do
            expected = [
              { month: Time.zone.parse('2023-02-01'), residence: 36_000 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire at the first period (Jun)' do
          let!(:retirement_month) { '2022-06-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2022-06-01'), residence: 30_500 },
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 27_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 27_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the second period (Aug)' do
          let!(:retirement_month) { '2022-07-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Aug, Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2022-07-01'), residence: 0 },
              { month: Time.zone.parse('2022-08-01'), residence: 33_000 },
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 33_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 33_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the third period (Oct)' do
          let!(:retirement_month) { '2022-09-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Oct, Jan' do
            expected = [
              { month: Time.zone.parse('2022-09-01'), residence: 0 },
              { month: Time.zone.parse('2022-10-01'), residence: 41_000 },
              { month: Time.zone.parse('2022-11-01'), residence: 0 },
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 40_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire before the fourth period (Jan)' do
          let!(:retirement_month) { '2022-12-01' }
          let!(:employment_month) { '2023-04-01' }

          it 'invoices special for retirement month ~ May in instalments in Jan at once' do
            expected = [
              { month: Time.zone.parse('2022-12-01'), residence: 0 },
              { month: Time.zone.parse('2023-01-01'), residence: 54_000 },
              { month: Time.zone.parse('2023-02-01'), residence: 0 },
              { month: Time.zone.parse('2023-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end
      end

      context 'when retiring in the year of the current date and starting work in that year' do
        let!(:simulation_date) { '2021-06-01' }
        context 'retire between Jan and May' do
          let!(:retirement_month) { '2022-02-01' }
          let!(:employment_month) { '2022-04-01' }

          it 'invoices the special for Jan to May of the year in the month of retirement at once' do
            # 退職したタイミングでは「いつ就職するか」はわからないため、問答無用でDOES NOT invoice any請求される
            expected = [
              { month: Time.zone.parse('2022-02-01'), residence: 80_000 },
              { month: Time.zone.parse('2022-03-01'), residence: 0 }
            ]
            expect(subject).to eq expected
          end
        end

        context 'retire at the first period (Jun)' do
          let!(:retirement_month) { '2021-06-01' }

          # 就職月は退職月の翌月以降に制限するので、6月にやめて6月に転職するケースはない
          context 'employ before the second period (Aug)' do
            let!(:employment_month) { '2021-08-01' }

            it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan and payment target is only Jan' do
              expected = [
                { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                { month: Time.zone.parse('2021-07-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ before the third period (Oct)' do
            let!(:employment_month) { '2021-10-01' }

            it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan and payment target is June and Aug' do
              expected = [
                { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ before the fourth period (Jan)' do
            let!(:employment_month) { '2022-01-01' }

            it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan and payment target is June, Aug and Oct' do
              expected = [
                { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 60_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ after the fourth period (Feb ~ May)' do
            let!(:employment_month) { '2022-05-01' }

            it 'invoices special for retirement month ~ May in instalments in Jun, Aug, Oct, Jan and payment target is June, Aug, Oct and Jan' do
              expected = [
                { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 60_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 },
                { month: Time.zone.parse('2022-01-01'), residence: 60_000 },
                { month: Time.zone.parse('2022-02-01'), residence: 0 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 },
                { month: Time.zone.parse('2022-04-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end
        end

        context 'retire before the second period (Aug)' do
          let!(:retirement_month) { '2021-07-01' }

          # 7月にやめて8月に就職するケース
          context 'retire before the second period (Aug)' do
            let!(:employment_month) { '2021-08-01' }

            it 'DOES NOT invoice any' do
              expected = [
                { month: Time.zone.parse('2021-07-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ before the third period (Oct)' do
            let!(:employment_month) { '2021-10-01' }

            it 'invoices special for retirement month ~ May in instalments in Aug, Oct, Jan and payment target is only Aug' do
              expected = [
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ before the fourth period (Jan)' do
            let!(:employment_month) { '2022-01-01' }

            it 'invoices special for retirement month ~ May in instalments in Aug, Oct, Jan and payment target is Aug and Oct' do
              expected = [
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 73_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ after the fourth period (Feb ~ May)' do
            let!(:employment_month) { '2022-05-01' }

            it 'invoices special for retirement month ~ May in instalments in Aug, Oct, Jan and payment target is Aug, Oct and Jan' do
              expected = [
                { month: Time.zone.parse('2021-07-01'), residence: 0 },
                { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 73_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 },
                { month: Time.zone.parse('2022-01-01'), residence: 73_000 },
                { month: Time.zone.parse('2022-02-01'), residence: 0 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 },
                { month: Time.zone.parse('2022-04-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end
        end

        context 'retire before the third period (Oct)' do
          let!(:retirement_month) { '2021-09-01' }

          # 9月に退職して、10月に就職するケース
          context 'employ before the third period (Oct)' do
            let!(:employment_month) { '2021-10-01' }

            it 'DOES NOT invoice any' do
              expected = [
                { month: Time.zone.parse('2021-09-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ before the fourth period (Jan)' do
            let!(:employment_month) { '2022-01-01' }

            it 'invoices special for retirement month ~ May in instalments in Oct, Jan and payment target is only Oct' do
              expected = [
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 90_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ after the fourth period (Feb ~ May)' do
            let!(:employment_month) { '2022-05-01' }

            it 'invoices special for retirement month ~ May in instalments in Oct, Jan and payment target is Oct and Jan' do
              expected = [
                { month: Time.zone.parse('2021-09-01'), residence: 0 },
                { month: Time.zone.parse('2021-10-01'), residence: 90_000 },
                { month: Time.zone.parse('2021-11-01'), residence: 0 },
                { month: Time.zone.parse('2021-12-01'), residence: 0 },
                { month: Time.zone.parse('2022-01-01'), residence: 90_000 },
                { month: Time.zone.parse('2022-02-01'), residence: 0 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 },
                { month: Time.zone.parse('2022-04-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end
        end

        context 'retire before the fourth period (Jan)' do
          let!(:retirement_month) { '2021-12-01' }

          context 'employ before the fourth period (Jan)' do
            let!(:employment_month) { '2022-01-01' }

            it 'DOES NOT invoice any' do
              expected = [
                { month: Time.zone.parse('2021-12-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context 'employ after the fourth period (Feb ~ May)' do
            let!(:employment_month) { '2022-05-01' }

            it 'invoices the special for Jan to May of the year in January at once' do
              expected = [
                { month: Time.zone.parse('2021-12-01'), residence: 0 },
                { month: Time.zone.parse('2022-01-01'), residence: 120_000 },
                { month: Time.zone.parse('2022-02-01'), residence: 0 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 },
                { month: Time.zone.parse('2022-04-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end
        end
      end

      context 'when retiring in the year of the current date and starting work in the NEXT year' do
        let!(:simulation_date) { '2021-06-01' }
        let!(:retirement_month) { '2021-07-01' }
        let!(:employment_month) { '2022-07-01' }

        it 'it invoices special of retirement year as an ordinary in instalments and next year is ordinary , and payment target is the month before employ' do
          expected = [
            { month: Time.zone.parse('2021-07-01'), residence: 0 },
            { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
            { month: Time.zone.parse('2021-09-01'), residence: 0 },
            { month: Time.zone.parse('2021-10-01'), residence: 73_000 },
            { month: Time.zone.parse('2021-11-01'), residence: 0 },
            { month: Time.zone.parse('2021-12-01'), residence: 0 },
            { month: Time.zone.parse('2022-01-01'), residence: 73_000 },
            { month: Time.zone.parse('2022-02-01'), residence: 0 },
            { month: Time.zone.parse('2022-03-01'), residence: 0 },
            { month: Time.zone.parse('2022-04-01'), residence: 0 },
            { month: Time.zone.parse('2022-05-01'), residence: 0 },
            { month: Time.zone.parse('2022-06-01'), residence: 30_500 }
          ]
          expect(subject).to eq expected
        end
      end

      context 'when retiring in the NEXT year of the current date and starting work in that year' do
        let!(:simulation_date) { '2021-06-01' }
        let!(:retirement_month) { '2022-07-01' }
        let!(:employment_month) { '2022-11-01' }

        it 'it invoices special of retirement year as an ordinary in instalments and next year is ordinary , and payment target is the month before employ' do
          expected = [
            { month: Time.zone.parse('2022-07-01'), residence: 0 },
            { month: Time.zone.parse('2022-08-01'), residence: 33_000 },
            { month: Time.zone.parse('2022-09-01'), residence: 0 },
            { month: Time.zone.parse('2022-10-01'), residence: 33_000 }
          ]
          expect(subject).to eq expected
        end
      end
    end

    context 'salary <= 1,000,000' do
      let!(:previous_salary) { 0 }
      let!(:salary) { 0 }
      let!(:social_insurance) { 0 }
      let!(:scheduled_salary) { 0 }
      let!(:scheduled_social_insurance) { 0 }
      let!(:simulation_date) { '2021-06-01' }
      let!(:retirement_month) { '2021-06-01' }
      let!(:employment_month) { '2023-04-01' }

      it 'should calculate residence (= income_basis + capita_basis) as 0' do
        expected = [
          { month: Time.zone.parse('2021-06-01'), residence: 0 },
          { month: Time.zone.parse('2021-07-01'), residence: 0 },
          { month: Time.zone.parse('2021-08-01'), residence: 0 },
          { month: Time.zone.parse('2021-09-01'), residence: 0 },
          { month: Time.zone.parse('2021-10-01'), residence: 0 },
          { month: Time.zone.parse('2021-11-01'), residence: 0 },
          { month: Time.zone.parse('2021-12-01'), residence: 0 },
          { month: Time.zone.parse('2022-01-01'), residence: 0 },
          { month: Time.zone.parse('2022-02-01'), residence: 0 },
          { month: Time.zone.parse('2022-03-01'), residence: 0 },
          { month: Time.zone.parse('2022-04-01'), residence: 0 },
          { month: Time.zone.parse('2022-05-01'), residence: 0 },
          { month: Time.zone.parse('2022-06-01'), residence: 0 },
          { month: Time.zone.parse('2022-07-01'), residence: 0 },
          { month: Time.zone.parse('2022-08-01'), residence: 0 },
          { month: Time.zone.parse('2022-09-01'), residence: 0 },
          { month: Time.zone.parse('2022-10-01'), residence: 0 },
          { month: Time.zone.parse('2022-11-01'), residence: 0 },
          { month: Time.zone.parse('2022-12-01'), residence: 0 },
          { month: Time.zone.parse('2023-01-01'), residence: 0 },
          { month: Time.zone.parse('2023-02-01'), residence: 0 },
          { month: Time.zone.parse('2023-03-01'), residence: 0 }
        ]
        expect(subject).to eq expected
      end
    end
  end
end

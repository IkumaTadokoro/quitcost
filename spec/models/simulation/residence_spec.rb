# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Residence, type: :model do
  describe '.call' do
    subject { Simulation::Residence.calc(param_parser) }
    let(:param_parser) do
      double(
        'ParamParser',
        retirement_month: retirement_month,
        employment_month: employment_month,
        salary_table: { 2021 => salary, 2022 => scheduled_salary },
        social_insurance_table: { 2021 => social_insurance, 2022 => scheduled_social_insurance }
      )
    end

    context '給与収入が1,000,000より大きい場合' do
      let!(:salary) { 4_988_682 }
      let!(:social_insurance) { 736_489 }
      let!(:scheduled_salary) { 3_000_000 }
      let!(:scheduled_social_insurance) { 500_000 }
      context '年度の途中で退職し、年度のおわりまで無職でいる場合' do
        context '現在日付の年度で退職し、その年度のおわりまで無職でいる場合' do
          context '1-3月に退職する場合' do
            let!(:retirement_month) { Time.zone.parse('2022-02-01') }
            let!(:employment_month) { Time.zone.parse('2022-06-01') }

            it '該当年度の1月~5月分の特別徴収額が、退職月に一括請求されること' do
              expected = [
                { month: Time.zone.parse('2022-02-01'), residence: 80_000 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 },
                { month: Time.zone.parse('2022-04-01'), residence: 0 },
                { month: Time.zone.parse('2022-05-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context '4-5月に退職する場合' do
            let!(:retirement_month) { Time.zone.parse('2022-04-01') }
            let!(:employment_month) { Time.zone.parse('2022-06-01') }

            it '該当年度の退職月~5月分の特別徴収額が、退職月に一括請求されること' do
              expected = [
                { month: Time.zone.parse('2022-04-01'), residence: 40_000 },
                { month: Time.zone.parse('2022-05-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context '6~12月に退職する場合' do
            let!(:employment_month) { Time.zone.parse('2022-06-01') }

            context '第1期（6月）に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-06-01') }

              it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になること' do
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

            context '第2期（8月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-07-01') }

              it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になること' do
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

            context '第3期（10月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-09-01') }

              it '該当年度の退職~5月分の特別徴収額が、10月と1月で分納になること' do
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

            context '第4期（1月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-12-01') }

              it '該当年度の退職~5月の特別徴収分が、1月に支払になること' do
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
        end

        context '現在日付の年度で退職し、翌年度のおわりまで無職でいる場合' do
          # 翌年度は国民健康保険料の都合上、3月分までしか表示できない（=翌々年度の4月に就職が制限）。
          context '1~5月に退職する場合' do
            let!(:retirement_month) { Time.zone.parse('2022-02-01') }
            let!(:employment_month) { Time.zone.parse('2023-04-01') }

            it '該当年度の1月~5月分の特別徴収額が退職月に一括請求され、翌年度の住民税が普通徴収されること' do
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

          context '6~12月に退職する場合' do
            let!(:employment_month) { Time.zone.parse('2023-04-01') }

            context '第1期（6月）に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-06-01') }

              it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になること、翌年度の住民税が普通徴収されること' do
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

            context '第2期（8月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-07-01') }

              it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になること、翌年度の住民税が普通徴収されること' do
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

            context '第3期（10月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-09-01') }

              it '該当年度の退職~5月分の特別徴収額が、10月と1月で分納になること、翌年度の住民税が普通徴収されること' do
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

            context '第4期（1月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-12-01') }

              it '該当年度の退職~5月分の特別徴収分が、1月に支払になること、翌年度の住民税が普通徴収されること' do
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
        end

        context '現在日付の翌年度の途中で退職し、その年度のおわりまで無職でいる場合' do
          # 翌年度は国民健康保険料の都合上、3月分までしか表示できない（=翌々年度の4月に就職が制限）。
          context '1~5月に退職する場合' do
            let!(:retirement_month) { Time.zone.parse('2023-02-01') }
            let!(:employment_month) { Time.zone.parse('2023-04-01') }

            it '該当年度の1月~5月分の特別徴収額が、退職月に一括請求されること' do
              expected = [
                { month: Time.zone.parse('2023-02-01'), residence: 36_000 },
                { month: Time.zone.parse('2023-03-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context '6~12月に退職する場合' do
            let!(:employment_month) { Time.zone.parse('2023-04-01') }

            context '第1期（6月）に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2022-06-01') }

              it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になること' do
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

            context '第2期（8月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2022-07-01') }

              it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になること' do
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

            context '第3期（10月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2022-09-01') }

              it '該当年度の退職~5月分の特別徴収額が、10月と1月で分納になること' do
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

            context '第4期（1月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2022-12-01') }

              it '該当年度の退職~5月の特別徴収分が、1月に支払になること' do
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
        end
      end

      context '年度の途中で退職し、年度の途中で就職する場合' do
        context '現在日付の年度で退職し、その年度の途中で就職する場合' do
          context '1~5月に退職する場合' do
            let!(:retirement_month) { Time.zone.parse('2022-02-01') }
            let!(:employment_month) { Time.zone.parse('2022-04-01') }

            it '該当年度の1~5月分の特別徴収額が、退職月に一括請求されること' do
              # 退職したタイミングでは「いつ就職するか」はわからないため、問答無用で一括請求される
              expected = [
                { month: Time.zone.parse('2022-02-01'), residence: 80_000 },
                { month: Time.zone.parse('2022-03-01'), residence: 0 }
              ]
              expect(subject).to eq expected
            end
          end

          context '6~12月に退職する場合' do
            context '第1期（6月）に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-06-01') }

              # 就職月は退職月の翌月以降に制限するので、6月にやめて6月に転職するケースはない
              context '第2期（8月）以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2021-08-01') }

                it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になり、6月のみ支払対象とすること' do
                  expected = [
                    { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                    { month: Time.zone.parse('2021-07-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第3期（10月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2021-10-01') }

                it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になり、6、8月分を支払対象とすること' do
                  expected = [
                    { month: Time.zone.parse('2021-06-01'), residence: 60_700 },
                    { month: Time.zone.parse('2021-07-01'), residence: 0 },
                    { month: Time.zone.parse('2021-08-01'), residence: 60_000 },
                    { month: Time.zone.parse('2021-09-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第4期（1月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-01-01') }

                it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になり、6、8、10月分を支払対象とすること' do
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

              context '第4期よりあと（2~5月）に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-05-01') }

                it '該当年度の退職~5月分の特別徴収額が、6,8,10,1月で分納になり、6、8、10、1月分を支払対象とすること' do
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

            context '第2期（8月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-07-01') }

              # 7月にやめて8月に就職するケース
              context '第2期（8月）以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2021-08-01') }

                it '支払いが発生しないこと' do
                  expected = [
                    { month: Time.zone.parse('2021-07-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第3期（10月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2021-10-01') }

                it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になり、8月分を支払対象とすること' do
                  expected = [
                    { month: Time.zone.parse('2021-07-01'), residence: 0 },
                    { month: Time.zone.parse('2021-08-01'), residence: 74_000 },
                    { month: Time.zone.parse('2021-09-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第4期（1月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-01-01') }

                it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になり、8、10月分を支払対象とすること' do
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

              context '第4期よりあと（2~5月）に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-05-01') }

                it '該当年度の退職~5月分の特別徴収額が、8,10,1月で分納になり、8、10、1月分を支払対象とすること' do
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

            context '第3期（10月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-09-01') }

              # 9月に退職して、10月に就職するケース
              context '第3期（10月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2021-10-01') }

                it '支払いが発生しないこと' do
                  expected = [
                    { month: Time.zone.parse('2021-09-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第4期（1月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-01-01') }

                it '該当年度の退職~5月分の特別徴収額が、10,1月で分納になり、10月分を支払対象とすること' do
                  expected = [
                    { month: Time.zone.parse('2021-09-01'), residence: 0 },
                    { month: Time.zone.parse('2021-10-01'), residence: 90_000 },
                    { month: Time.zone.parse('2021-11-01'), residence: 0 },
                    { month: Time.zone.parse('2021-12-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第4期よりあと（2~5月）に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-05-01') }

                it '該当年度の退職~5月分の特別徴収額が、10,1月で分納になり、1月分を支払対象とすること' do
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

            context '第4期（1月）以前に退職する場合' do
              let!(:retirement_month) { Time.zone.parse('2021-12-01') }

              context '第4期（1月)以前に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-01-01') }

                it '支払いが発生しないこと' do
                  expected = [
                    { month: Time.zone.parse('2021-12-01'), residence: 0 }
                  ]
                  expect(subject).to eq expected
                end
              end

              context '第4期よりあと（2~5月）に就職する場合' do
                let!(:employment_month) { Time.zone.parse('2022-05-01') }

                it '該当年度の退職~5月分の特別徴収額を1月支払いとすること' do
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
        end

        context '現在日付の年度で退職し、翌年度の途中で就職する場合' do
          let!(:retirement_month) { Time.zone.parse('2021-07-01') }
          let!(:employment_month) { Time.zone.parse('2022-07-01') }

          it '退職年度の金額が普通徴収として残りの納期に按分され、翌年度の料金は普通徴収として計算した上で就職する前月まで支払義務が発生すること' do
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

        context '現在日付の翌年度の途中で退職し、その年度の途中で就職する場合' do
          let!(:retirement_month) { Time.zone.parse('2022-07-01') }
          let!(:employment_month) { Time.zone.parse('2022-11-01') }

          it '退職年度の金額が普通徴収として残りの納期に按分され、翌年度の料金は普通徴収として計算した上で就職する前月まで支払義務が発生すること' do
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
    end

    context '給与収入が1,000,000以下の場合' do
      let!(:salary) { 0 }
      let!(:social_insurance) { 0 }
      let!(:scheduled_salary) { 0 }
      let!(:scheduled_social_insurance) { 0 }
      let!(:retirement_month) { Time.zone.parse('2021-06-01') }
      let!(:employment_month) { Time.zone.parse('2023-04-01') }

      it '所得税が（所得割、均等割ともに）0になること' do
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

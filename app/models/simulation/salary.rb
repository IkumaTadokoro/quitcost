# frozen_string_literal: true

class Simulation::Salary
  TABLE = {
    0..550_999 => { plus: 0, multiply: 0, divide: 1 },
    551_000..1_618_999 => { plus: -550_000, multiply: 1, divide: 1 },
    1_619_000..1_619_999 => { plus: 1_069_000, multiply: 0, divide: 1 },
    1_620_000..1_621_999 => { plus: 1_070_000, multiply: 0, divide: 1 },
    1_622_000..1_623_999 => { plus: 1_072_000, multiply: 0, divide: 1 },
    1_624_000..1_627_999 => { plus: 1_074_000, multiply: 0, divide: 1 },
    1_628_000..1_799_999 => { plus: 100_000, multiply: 2.4, divide: 4 },
    1_800_000..3_599_999 => { plus: -80_000, multiply: 2.8, divide: 4 },
    3_600_000..6_599_999 => { plus: -440_000, multiply: 3.2, divide: 4 },
    6_600_000..8_499_999 => { plus: -1_100_000, multiply: 0.9, divide: 1 },
    8_500_000.. => { plus: -1_950_000, multiply: 1, divide: 1 }
  }.freeze

  def self.call(income)
    new(income).call
  end

  def initialize(income)
    @income = income
  end

  def call
    calculate_salary
  end

  private

  attr_reader :income

  def calculate_salary
    value = TABLE.select { |row| row.include?(income) }.values.first
    base = value[:divide] == 1 ? income : (income / value[:divide]).floor(-3)
    (base * value[:multiply]).floor + value[:plus]
  end
end

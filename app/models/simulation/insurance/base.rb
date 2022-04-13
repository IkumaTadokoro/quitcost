# frozen_string_literal: true

class Simulation::Insurance::Base
  BASIC_DEDUCTION = 430_000

  def self.calc(year:, local_gov_code:, income:, age:)
    new(year, local_gov_code, income, age).calculate
  end

  def initialize(year, local_gov_code, income, age)
    @income = income
    @rate = Insurance.rate(year: year, local_gov_code: local_gov_code)
    @age = age
  end

  def calculate
    return 0 if age >= 75

    limit = rate.send("#{name}_limit")
    calculate_result = income_basis + capita_basis + household_basis
    calculate_result <= limit ? calculate_result : limit
  end

  protected

  attr_reader :rate, :age

  # 所得割
  def income_basis
    (salary * rate.send("#{name}_income_basis") / 100).round
  end

  # 均等割
  def capita_basis
    rate.send("#{name}_capita_basis")
  end

  # 世帯割
  def household_basis
    rate.send("#{name}_household_basis")
  end

  def name
    self.class.name.demodulize.downcase
  end

  def salary
    candidate = Simulation::Salary.calc(@income) - BASIC_DEDUCTION
    candidate.positive? ? candidate : 0
  end
end

# frozen_string_literal: true

class RequiredSalaryAndSocialInsuranceValidator < ActiveModel::Validator
  def validate(record)
    targets = []
    targets.push(:previous_salary, :previous_social_insurance) if require_previous?(record)
    targets.push(:salary, :social_insurance) if require_current?(record)
    targets.push(:scheduled_salary, :scheduled_social_insurance) if require_scheduled?(record)

    targets.each { |target| record.errors.add(target, 'は必須です') if record.send(target).nil? }
  end

  private

  def require_previous?(record)
    record.retirement_month < record.simulation_date.beginning_of_financial_year.advance(months: 2)
  end

  def require_current?(record)
    record.retirement_month < record.simulation_date.beginning_of_financial_year.advance(months: 2, years: 1)
  end

  def require_scheduled?(record)
    record.employment_month >= record.simulation_date.beginning_of_financial_year.advance(years: 1)
  end
end

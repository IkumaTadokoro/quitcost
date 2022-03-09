# frozen_string_literal: true

module Simulation::Residence::FinancialYearStartWithJune
  # Refs: config/initializers/fiscali.rb
  refine ActiveSupport::TimeWithZone do
    def beginning_of_residence_fy
      prev_month.prev_month.beginning_of_financial_year.next_month.next_month
    end

    def residence_financial_year
      prev_month.prev_month.financial_year
    end
  end
end

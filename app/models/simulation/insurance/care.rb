# frozen_string_literal: true

class Simulation::Insurance::Care < Simulation::Insurance::Base
  def calculate
    return 0 if @age < 40 || @age >= 65

    super
  end
end

# frozen_string_literal: true

class Pention < ApplicationRecord
  paginates_per 20

  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: true
  validates :contribution, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end

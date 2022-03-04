# frozen_string_literal: true

module MonthIterable
  def months_between(from:, to:)
    Enumerator.produce(from, &:next_month).take_while { |date| date < to }
  end
end

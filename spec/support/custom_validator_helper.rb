# frozen_string_literal: true

module CustomValidatorHelper
  def build_validator_mock(attribute: nil, record: nil, validator: nil, options: nil)
    record    ||= :record
    attribute ||= :attribute
    validator ||= described_class.to_s.underscore.gsub(/_validator\Z/, '').to_sym
    options   ||= true

    Struct.new(attribute, *record, keyword_init: true) do
      include ActiveModel::Validations

      def self.name
        'DummyModel'
      end

      validates attribute, validator => options
    end
  end
end

RSpec.configure do |config|
  config.include CustomValidatorHelper, type: :model
end

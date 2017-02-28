# frozen_string_literal: true
module Arel
  class TemporaryTable < Table
    attr_accessor :data_source

    def initialize(data_source, as:, type_caster: nil)
      super(as, type_caster: type_caster)
      @data_source = data_source
    end
  end
end

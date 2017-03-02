# frozen_string_literal: true
module Arel
  class TemporaryTable < Table
    attr_accessor :data_source

    def initialize(data_source, as: default_name, type_caster: nil)
      super(as, type_caster: type_caster)
      @data_source = data_source
    end

    private

    def default_name
      Array.new(10) { Random.rand(97..122) }.map(&:chr).join
    end
  end
end

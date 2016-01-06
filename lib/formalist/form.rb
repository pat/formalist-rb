require "formalist/form/definition"

module Formalist
  class Form
    extend Definition.with_builders(:attr, :field, :group, :many, :section)

    # @api private
    attr_reader :schema

    def initialize(schema: nil)
      @schema = schema
    end

    def call(input, validate: true)
      error_messages = validate ? schema.(input).messages : {}

      form_ast = self.class.elements.map { |el| el.(input, error_messages) }
    end
  end
end

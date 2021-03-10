require "formalist/element/attributes"
require "formalist/element/class_interface"

module Formalist
  class Element
    extend ClassInterface

    # @api private
    attr_reader :name, :attributes, :children, :input, :errors, :meta

    # @api private
    def self.build(**args)
      new(**args)
    end

    # @api private
    def self.fill(input: {}, errors: {}, meta: {}, **args)
      new(args).fill(input: input, errors: errors)
    end

    # @api private
    def initialize(name: nil, attributes: {}, children: [], input: nil, errors: [], meta: {})
      @name = name&.to_sym

      @attributes = self.class.attributes_schema.each_with_object({}) { |(name, defn), hsh|
        value = attributes.fetch(name) { defn[:default] }
        hsh[name] = value unless value.nil?
      }

      @children = children
      @input = input
      @errors = errors
      @meta = meta
    end

    def fill(input: {}, errors: {}, meta: {}, **args)
      return self if input == @input && errors == @errors && @meta == meta

      args = {
        name: @name,
        attributes: @attributes,
        children: @children,
        input: input,
        errors: errors,
        meta: meta,
      }.merge(args)

      self.class.new(**args)
    end

    def type
      self.class.type
    end

    def ==(other)
      name && type == other.type && name == other.name
    end

    # @abstract
    def to_ast
      raise NotImplementedError
    end
  end
end

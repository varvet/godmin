module Godmin
  module Filter
    class String < Base
      attr_reader :wildcard

      def initialize(identifier, wildcard: :none, **)
        super
        @wildcard = wildcard
      end

      def call(resources, value)
        if wildcard == :none
          resources.where(column => value)
        else
          resources.where("#{column} LIKE ?", wildcard_query(value))
        end
      end

      private

      def wildcard_query(value)
        case wildcard
        when :pre
          "%#{value}"
        when :post
          "#{value}%"
        when :both
          "%#{value}%"
        end
      end
    end
  end
end

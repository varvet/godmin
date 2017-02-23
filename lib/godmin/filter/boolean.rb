module Godmin
  module Filter
    class Boolean < Base
      attr_reader :collection

      def initialize(identifier, collection: [["True", 1], ["False", 0]], **)
        super
        @collection = collection
      end

      def call(value, scope)
        value = value == "0" ? false : true
        scope.where(column => value)
      end
    end
  end
end

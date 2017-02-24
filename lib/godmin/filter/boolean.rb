module Godmin
  module Filter
    class Boolean < Select
      attr_reader :collection

      def initialize(identifier, true_label: "True", false_label: "False", **)
        super
        @collection = [[true_label, 1], [false_label, 0]]
      end

      def call(resources, value)
        super(resources, value == "1")
      end
    end
  end
end

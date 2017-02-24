module Godmin
  module Filter
    class Select < Base
      attr_reader :collection, :option_text, :option_value

      def initialize(identifier, collection: [], option_text: :to_s, option_value: :id, **)
        super
        @collection = collection
        @option_text = option_text
        @option_value = option_value
      end

      def call(resources, value)
        resources.where(column => value)
      end
    end
  end
end

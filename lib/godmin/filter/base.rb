module Godmin
  module Filter
    class Base
      attr_reader :identifier, :column

      def initialize(identifier, column: identifier, **)
        @identifier = identifier
        @column = column
      end

      def to_partial_path
        "filters/#{class_name}"
      end

      protected

      def class_name
        self.class.to_s.split("::").last.underscore
      end
    end
  end
end

require "godmin/generators/base"

module Godmin
  module Generators
    class NamedBase < Base
      argument :name, type: :string

      private

      def class_name
        @class_name ||= name.classify
      end

      def class_path
        @class_path ||= namespaced_path + name.classify.deconstantize.split("::").map(&:underscore)
      end

      def file_name
        @file_name ||= class_name.demodulize.underscore
      end
    end
  end
end

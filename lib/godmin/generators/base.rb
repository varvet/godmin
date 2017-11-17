require "active_support/all"

module Godmin
  module Generators
    class Base < Rails::Generators::Base
      def self.source_paths
        %w[authentication install policy resource].map do |path|
          File.expand_path("../../../generators/godmin/#{path}/templates", __FILE__)
        end
      end

      private

      def namespace
        @_namespace ||= Rails::Generators.namespace
      end

      def namespaced?
        @_namespaced ||= namespace.present?
      end

      def namespaced_path
        @_namespaced_path ||= begin
          if namespaced?
            namespace.name.split("::").map(&:underscore)
          else
            []
          end
        end
      end

      def module_namespacing(&block)
        content = capture(&block)
        content = wrap_with_namespace(content) if namespaced?
        concat(content)
      end

      def indent(content, multiplier = 2)
        spaces = " " * multiplier
        content.each_line.map { |line| line.blank? ? line : "#{spaces}#{line}" }.join
      end

      def wrap_with_namespace(content)
        content = indent(content).chomp
        "module #{namespace.name}\n#{content}\nend\n"
      end
    end
  end
end

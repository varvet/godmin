module Godmin
  module Helpers
    module Forms
      def form_for(record, options = {}, &block)
        super do |form_builder|
          yield Godmin::FormBuilder.new(form_builder)
        end
      end
    end
  end

  class FormBuilder < SimpleDelegator; end
end

module Godmin
  module Helpers
    module Forms
      def form_for(record, options = {}, &block)
        super(record, { builder: FormBuilders::FormBuilder }.merge(options), &block)
      end

      def simple_form_for(record, options = {}, &block)
        super(record, { builder: FormBuilders::SimpleFormBuilder }.merge(options), &block)
      end
    end
  end

  module FormBuilders
    class FormBuilder < ActionView::Helpers::FormBuilder; end
    class SimpleFormBuilder < SimpleForm::FormBuilder; end
  end
end

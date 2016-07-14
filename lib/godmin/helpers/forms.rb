module Godmin
  module Helpers
    module Forms
      def form_for(record, options = {}, &block)
        super(record, { builder: FormBuilders::FormBuilder, inline_errors: false }.merge(options), &block)
      end
    end
  end

  module FormBuilders
    class FormBuilder < BootstrapForm::FormBuilder
      def input(attribute, options = {})
        case attribute_type(attribute)
        when :text
          text_area(attribute, options)
        when :boolean
          check_box(attribute, options)
        when :date
          date_field(attribute, options)
        when :datetime
          datetime_field(attribute, options)
        else
          text_field(attribute, options)
        end
      end

      def association(attribute, options = {}, html_options = {})
        case association_type(attribute)
        when :belongs_to
          select("#{attribute}_id", association_collection_for_select(attribute), options, html_options.deep_merge(
            data: { behavior: "select-box" }
          ))
        else
          input(attribute, options)
        end
      end

      def date_field(attribute, options = {})
        text_field(attribute, options.deep_merge(
          value: datetime_value(attribute, options, :datepicker),
          data: { behavior: "datepicker" }
        ))
      end

      def datetime_field(attribute, options = {})
        text_field(attribute, options.deep_merge(
          value: datetime_value(attribute, options, :datetimepicker),
          data: { behavior: "datetimepicker" }
        ))
      end

      private

      def attribute_type(attribute)
        if @object.has_attribute?(attribute)
          @object.column_for_attribute(attribute).type
        end
      end

      def association_type(attribute)
        association_reflection(attribute).try(:macro)
      end

      def association_collection(attribute)
        association_reflection(attribute).try(:klass).try(:all)
      end

      def association_reflection(attribute)
        @object.class.reflect_on_association(attribute)
      end

      def association_collection_for_select(attribute)
        association_collection(attribute).map { |a| [a.to_s, a.id] }
      end

      def datetime_value(attribute, options, format)
        value = options[:value] || @object.send(attribute)
        value.try(:strftime, @template.translate_scoped("datetimepickers.#{format}"))
      end
    end
  end
end

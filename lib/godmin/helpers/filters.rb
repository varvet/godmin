module Godmin
  module Helpers
    module Filters
      def filter_form(url: params.to_unsafe_h)
        bootstrap_form_tag url: url, method: :get, layout: :inline, builder: FormBuilders::FilterFormBuilder do |f|
          yield(f)
        end
      end
    end
  end

  module FormBuilders
    class FilterFormBuilder < BootstrapForm::FormBuilder
      def string_filter_field(filter, html_options = {})
        text_field(
          filter.identifier, {
            name: "filter[#{filter.identifier}]",
            label: @template.translate_scoped("filters.labels.#{filter.identifier}", default: filter.identifier.to_s.titleize),
            value: default_filter_value(filter.identifier),
            placeholder: @template.translate_scoped("filters.labels.#{filter.identifier}", default: filter.identifier.to_s.titleize),
            wrapper_class: "filter"
          }.deep_merge(html_options)
        )
      end

      def select_filter_field(filter, options = {}, html_options = {})
        filter_select(
          filter, options, {
            name: "filter[#{filter.identifier}]",
            data: {
              placeholder: @template.translate_scoped("filters.select.placeholder.one")
            }
          }.deep_merge(html_options)
        )
      end

      def multiselect_filter_field(filter, options = {}, html_options = {})
        filter_select(
          filter, {
            include_hidden: false
          }.deep_merge(options), {
            name: "filter[#{filter.identifier}][]",
            multiple: true,
            data: {
              placeholder: @template.translate_scoped("filters.select.placeholder.many")
            }
          }.deep_merge(html_options)
        )
      end

      def apply_filters_button
        submit @template.translate_scoped("filters.buttons.apply")
      end

      def clear_filters_button
        @template.link_to(
          @template.translate_scoped("filters.buttons.clear"),
          @template.url_for(
            @template.params.to_unsafe_h.slice(:scope, :order)
          ),
          class: "btn btn-default"
        )
      end

      private

      def filter_select(filter, options, html_options)
        collection = filter.collection

        choices =
          if collection.is_a? ActiveRecord::Relation
            @template.options_from_collection_for_select(
              collection,
              filter.option_value,
              filter.option_text,
              selected: default_filter_value(filter.identifier)
            )
          else
            @template.options_for_select(
              collection,
              selected: default_filter_value(filter.identifier)
            )
          end

        select(
          filter.identifier, choices, {
            label: @template.translate_scoped("filters.labels.#{filter.identifier}", default: filter.identifier.to_s.titleize),
            include_hidden: true,
            include_blank: true
          }.deep_merge(options), {
            data: { behavior: "select-box" },
            wrapper_class: "filter"
          }.deep_merge(html_options)
        )
      end

      def default_filter_value(name)
        @template.params[:filter] ? @template.params[:filter][name] : nil
      end
    end
  end
end

module Godmin
  module Helpers
    module Filters
      def filter_form(url: params)
        bootstrap_form_tag url: url, method: :get, layout: :inline, builder: FormBuilders::FilterFormBuilder do |f|
          yield(f)
        end
      end
    end
  end

  module FormBuilders
    class FilterFormBuilder < BootstrapForm::FormBuilder
      def filter_field(name, options, html_options = {})
        case options[:as]
        when :string
          string_filter_field(name, options, html_options)
        when :select
          select_filter_field(name, options, html_options)
        when :multiselect
          multiselect_filter_field(name, options, html_options)
        end
      end

      def string_filter_field(name, _options, html_options = {})
        text_field(
          name, {
            name: "filter[#{name}]",
            label: @template.translate_scoped("filters.labels.#{name}", default: name.to_s.titleize),
            value: default_filter_value(name),
            placeholder: @template.translate_scoped("filters.labels.#{name}", default: name.to_s.titleize),
            wrapper_class: "filter"
          }.deep_merge(html_options)
        )
      end

      def select_filter_field(name, options, html_options = {})
        filter_select(
          name, options, {
            name: "filter[#{name}]",
            data: {
              placeholder: @template.translate_scoped("filters.select.placeholder.one")
            }
          }.deep_merge(html_options)
        )
      end

      def multiselect_filter_field(name, options, html_options = {})
        filter_select(
          name, {
            include_hidden: false
          }.deep_merge(options), {
            name: "filter[#{name}][]",
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
            @template.params.slice(:scope, :order)
          ),
          class: "btn btn-default"
        )
      end

      private

      def filter_select(name, options, html_options)
        unless options[:collection].is_a? Proc
          fail "A collection proc must be specified for select filters"
        end

        collection = options.delete(:collection).call

        choices =
          if collection.is_a? ActiveRecord::Relation
            @template.options_from_collection_for_select(
              collection,
              options.delete(:option_value),
              options.delete(:option_text),
              selected: default_filter_value(name)
            )
          else
            @template.options_for_select(
              collection,
              selected: default_filter_value(name)
            )
          end

        select(
          name, choices, {
            wrapper_class: "filter",
            label: @template.translate_scoped("filters.labels.#{name}", default: name.to_s.titleize),
            include_hidden: true,
            include_blank: true
          }.deep_merge(options), {
            data: { behavior: "select-box" }
          }.deep_merge(html_options)
        )
      end

      def default_filter_value(name)
        @template.params[:filter] ? @template.params[:filter][name] : nil
      end
    end
  end
end

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
            @template.params.to_unsafe_h.slice(:scope, :order)
          ),
          class: "btn btn-default"
        )
      end

      private

      def filter_select(name, options, html_options)
        unless options[:collection].is_a? Proc
          raise "A collection proc must be specified for select filters"
        end

        # We need to dup this here because we later delete some properties
        # from the hash. We should consider adding an additional options
        # param to separate filter params from select tag params.
        options = options.dup

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
            label: @template.translate_scoped("filters.labels.#{name}", default: name.to_s.titleize),
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

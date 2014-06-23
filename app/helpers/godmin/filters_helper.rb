module Godmin
  module FiltersHelper

    def filter_input_tag(name, options)
      case options[:as]
      when :string
        filter_string_tag(name, options)
      when :select
        filter_select_tag(name, options)
      when :multiselect
        filter_multiselect_tag(name, options)
      when :checkboxes
        filter_checkbox_tags(name, options)
      end
    end

    def filter_string_tag(name, options)
      text_field_tag(
        name,
        default_filter_value(name),
        name: "filter[#{name}]",
        class: "form-control",
        placeholder: godmin_translate("filters.labels.#{name}", default: name.to_s.titleize)
      )
    end

    def filter_select_tag(name, options)
      filter_select_tag_helper(name, options, {
        name: "filter[#{name}]",
        include_blank: true,
        class: "form-control select-tag",
        data: {
          placeholder: godmin_translate("filters.select.placeholder.one")
        }
      })
    end

    def filter_multiselect_tag(name, options)
      filter_select_tag_helper(name, options, {
        name: "filter[#{name}][]",
        multiple: true,
        class: "form-control select-tag",
        data: {
          placeholder: godmin_translate("filters.select.placeholder.many")
        }
      })
    end

    def filter_select_tag_helper(name, options, html_options)
      unless options[:collection].is_a? Proc
        raise "A collection proc must be specified for select filters"
      end

      collection = options[:collection].call

      if collection.is_a? ActiveRecord::Relation
        choices = options_from_collection_for_select(
          collection,
          options[:option_value],
          options[:option_text],
          selected: default_filter_value(name)
        )
      else
        choices = options_for_select(
          collection,
          selected: default_filter_value(name)
        )
      end

      select_tag(name, choices, html_options)
    end

    def filter_checkbox_tags(name, options)
      unless options[:collection].is_a? Proc
        raise "A collection proc must be specified for checkbox filters"
      end

      collection = options[:collection].call

      collection.map do |item|
        text, value = if !item.is_a?(String) && item.respond_to?(:first) && item.respond_to?(:last)
          [item.first.to_s, item.last.to_s]
        else
          [item.to_s, item.to_s]
        end

        is_checked = default_filter_value(name) ? default_filter_value(name).include?(value) : false

        content_tag :div, class: "checkbox" do
          label_tag("#{name}_#{value}") do
            check_box_tag("filter[#{name}][]", value, is_checked, id: "#{name}_#{value}") << text
          end
        end
      end.join("\n").html_safe
    end

    def default_filter_value(name)
      params[:filter] ? params[:filter][name] : nil
    end

  end
end

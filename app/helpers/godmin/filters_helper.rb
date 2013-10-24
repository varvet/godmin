module Godmin
  module FiltersHelper

    def filter_input_tag(name, options)
      case options[:as]
      when :string
        filter_string_tag(name)
      when :select
        filter_select_tag(name, options)
      when :multiselect
        filter_multiselect_tag(name, options)
      when :checkboxes
        filter_checkbox_tags(name, options)
      end
    end

    def filter_string_tag(name)
      text_field_tag(
        name,
        default_filter_value(name),
        :name => "filter[#{name}]",
        :class => 'form-control'
      )
    end

    def filter_select_tag(name, options)
      filter_select_tag_helper(name, options, {
        :name => "filter[#{name}]",
        :include_blank => true,
        :class => 'form-control chosen-with-deselect'
      })
    end

    def filter_multiselect_tag(name, options)
      filter_select_tag_helper(name, options, {
        :name => "filter[#{name}][]",
        :multiple => true,
        :class => 'form-control chosen'
      })
    end

    def filter_select_tag_helper(name, options, html_options)
      unless options[:collection].is_a? Proc
        raise 'A collection proc must be specified for select filters'
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
        raise 'A collection proc must be specified for checkbox filters'
      end

      collection = options[:collection].call
      
      collection.map do |item|
        item = Array(item)
        label_text = item[0]
        checkbox_value = item[1] || item[0]
        is_checked = default_filter_value(name) ? default_filter_value(name).include?(checkbox_value) : false

        content_tag :div, class: "checkbox" do
          label_tag("#{name}_#{checkbox_value}") do
            check_box_tag("filter[#{name}][]", checkbox_value, is_checked, id: "#{name}_#{checkbox_value}") << label_text
          end
        end
      end.join.html_safe

    end

    def default_filter_value(name)
      params[:filter] ? params[:filter][name] : nil
    end

  end
end

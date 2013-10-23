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
        raise 'A collection proc must be specified for filter select tags'
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

    def default_filter_value(name)
      params[:filter] ? params[:filter][name] : nil
    end

  end
end

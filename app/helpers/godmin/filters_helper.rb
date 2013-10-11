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

    protected

    def filter_string_tag(name)
      text_field_tag(
        name,
        default_value(name),
        :name => "filter[#{name}]",
        :class => 'form-control'
      )
    end

    def filter_select_tag(name, options)
      select_tag(
        name,
        options_from_collection_for_select(
          options[:collection].call,
          options[:select_value] || 'id',
          options[:select_label],
          :selected => default_value(name)
        ),
        :name => "filter[#{name}]",
        :include_blank => true,
        :class => 'form-control chosen-with-deselect'
      )
    end

    def filter_multiselect_tag(name, options)
      select_tag(
        name,
        options_from_collection_for_select(
          options[:collection].call,
          options[:select_value] || 'id',
          options[:select_label],
          :selected => default_value(name)
        ),
        :name => "filter[#{name}][]",
        :multiple => true,
        :class => 'form-control chosen'
      )
    end

    def default_value(name)
      params[:filter] ? params[:filter][name] : nil
    end

  end
end

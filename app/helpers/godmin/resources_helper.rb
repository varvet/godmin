module Godmin
  module ResourcesHelper

    def attr_header(attr)
      attr = attr.to_s

      if resource_class.column_names.include? attr
        if params[:order]
          direction = params[:order].split('_').last == 'desc' ? 'asc' : 'desc'
        else
          direction = 'desc'
        end
        header = link_to attr.titlecase, url_for(params.merge(order: "#{attr}_#{direction}"))
      else
        header = attr.titlecase
      end

      header
    end

  end
end

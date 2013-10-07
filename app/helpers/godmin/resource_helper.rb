module Godmin
  module ResourceHelper

    def column_header(resource_class, attr)
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

    def column(resource_class, resource, attr)
      template_name = "admin/#{resource_class.to_s.pluralize.underscore}/columns/#{attr}"
      if lookup_context.exists?(template_name, nil, true)
        render partial: template_name, locals: { resource: resource }
      else
        resource.send(attr.to_s)
      end
    end

  end
end

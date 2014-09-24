module Godmin
  module Helpers
    module Render
      extend ActiveSupport::Concern

      # TODO: see http://rubydoc.info/docs/rails/ActionView/LookupContext
      # TODO: see http://stackoverflow.com/questions/272509/how-can-i-explicitly-declare-a-view-from-a-rails-controller

      # included do
      #   helper_method :godmin_render_partial
      # end
      #
      # def godmin_render_partial(partial, locals: {})
      #   view_context.render partial: (godmin_locate_partial(partial) || partial), locals: locals
      # end
      #
      # private
      #
      # def godmin_locate_partial(partial)
      #   paths = [
      #     [Godmin.mounted_as, @resource_class.to_s.underscore.pluralize].compact.join("/"),
      #     [Godmin.mounted_as, "resource"].compact.join("/"),
      #     [Godmin.mounted_as].compact.join("/"),
      #     "godmin/resource",
      #     "godmin"
      #   ]
      #
      #   located_partial = nil
      #
      #   paths.each do |path|
      #     if view_context.lookup_context.exists?("#{path}/#{partial}", nil, true)
      #       located_partial = "#{path}/#{partial}"; break
      #     end
      #   end
      #
      #   located_partial
      # end
    end
  end
end

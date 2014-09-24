module Godmin
  module Application
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Render
      include Godmin::Helpers::Translate


      # append_view_path Godmin::Resolver.new

      # before_action :set_resolver_foo_yeah
      # before_action :set_lookup_context

      # layout "godmin/application"
    end

    # TODO: works but without layout
    def _prefixes
      ["godmin/application"]
    end

    def welcome
      # render "welcome-no"
      # godmin_render_template "welcome"
      # render "godmin/application/welcome", layout: "godmin/application"
    end

    private

    # def set_resolver_foo_yeah
    #   debugger
    #   puts "yeah"
    #   # append_view_path Godmin::Resolver.new("app/views")
    # end

    # TODO: works but without layout
    # def set_lookup_context
    #   view_context.lookup_context.prefixes << "godmin/application"
    # end
  end
end

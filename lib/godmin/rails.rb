module ActionDispatch::Routing
  class Mapper

    def godmin
      override_devise_for do
        override_resources do
          yield
        end
      end

      unless has_named_route?(:root)
        root to: "application#welcome"
      end
    end

    private

    # TODO: not sure why we need this here but not for resources...
    alias_method :original_devise_for, :devise_for

    def override_devise_for
      def devise_for(*resources)
        Rails.application.routes.draw do
          scope Godmin.mounted_as do
            original_devise_for(*resources, {
              controllers: {
                passwords: "godmin/devise/passwords",
                registrations: "godmin/devise/registrations",
                sessions: "godmin/devise/sessions"
              }
            }.deep_merge(resources.extract_options!))
          end
        end
      end

      yield

      def devise_for(*resources)
        original_devise_for(*resources)
      end
    end

    def override_resources
      def resources(*resources, &block)
        unless Godmin.resources.include?(resources.first)
          Godmin.resources << resources.first
        end

        super do
          post "batch_action", on: :collection
        end
      end

      yield

      def resources(*resources, &block)
        super
      end
    end

  end
end

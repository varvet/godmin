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

    # TODO: it would be nice if this could be replaced with super calls
    alias_method :_devise_for, :devise_for

    def override_devise_for
      def devise_for(*resources)
        Rails.application.routes.draw do
          scope Godmin.mounted_as do
            _devise_for(*resources, {
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
        _devise_for(*resources)
      end
    end

    # TODO: it would be nice if this could be replaced with super calls
    alias_method :_resources, :resources

    def override_resources
      def resources(*resources, &block)
        unless Godmin.resources.include?(resources.first)
          Godmin.resources << resources.first
        end

        _resources(*resources) do
          if block
            block.call
          end
          post "batch_action", on: :collection
        end
      end

      yield

      def resources(*resources, &block)
        _resources(*resources, &block)
      end
    end

  end
end

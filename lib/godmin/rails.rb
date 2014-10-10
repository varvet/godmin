module ActionDispatch::Routing
  class Mapper

    def godmin
      override_resources do
        yield
      end

      unless has_named_route?(:root)
        root to: "application#welcome"
      end
    end

    private

    # TODO: it would be nice if this could be replaced with super calls
    alias_method :_resources, :resources

    def override_resources
      def resources(*resources)
        unless Godmin.resources.include?(resources.first)
          Godmin.resources << resources.first
        end

        _resources(*resources) do
          yield if block_given?
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

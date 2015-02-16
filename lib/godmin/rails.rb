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

    def override_resources
      def resources(*resources)
        unless Godmin.resources.include?(resources.first)
          Godmin.resources << resources.first
        end

        super
        # super(*resources) do
        #   if block_given?
        #     yield
        #   end
        #   # post "batch_action", on: :collection
        # end
      end

      yield

      def resources(*resources, &block)
        super(*resources, &block)
      end
    end
  end
end

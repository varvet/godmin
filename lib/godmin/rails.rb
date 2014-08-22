module ActionDispatch::Routing
  class Mapper

    def godmin
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

      unless has_named_route?(:root)
        root to: "application#welcome"
      end
    end

  end
end

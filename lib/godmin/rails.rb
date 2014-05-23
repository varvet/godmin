module ActionDispatch::Routing
  class Mapper

    def godmin
      def resources(*resources, &block)
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

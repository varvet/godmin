module ActionDispatch::Routing
  class Mapper

    def embrace_godmin(name)
      mount Godmin::Engine, at: name

      namespace name.to_sym do
        yield
      end

      Godmin.mounted_as = name
    end

    def watches_over(resource)
      resources resource do
        post "batch_action", on: :collection
        yield if block_given?
      end
    end

    # def godmin_for(name)
    #   mount Godmin::Engine, at: name

    #   namespace name.to_sym do
    #     yield
    #   end

    #   Godmin.mounted_as = name
    # end

    # def resources(*resources, &block)
    #   super do
    #     post "batch_action", on: :collection
    #   end
    # end

    # # TODO: legacy names
    # alias_method :embrace_godmin, :godmin_for
    # alias_method :watches_over, :resources

  end
end

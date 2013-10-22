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
        post 'batch_action', on: :collection
        yield if block_given?
      end
    end

  end
end

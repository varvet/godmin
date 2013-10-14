module ActionDispatch::Routing
  class Mapper

    def embrace_godmin(name)
      mount Godmin::Engine, at: name

      namespace name.to_sym do
        yield
      end

      Godmin.mounted_as = name
    end

  end
end

module Godmin
  class Engine < ::Rails::Engine
    isolate_namespace Godmin
    paths["app/views"] << "app/views/godmin/resource"
    paths["app/views"] << "app/views/godmin"
  end
end

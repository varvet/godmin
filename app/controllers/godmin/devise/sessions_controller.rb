# class Class
#   def include_refined(klass)
#     _refinement = Module.new do
#       include refine(klass) {
#         yield if block_given?
#       }
#     end
#     self.send :include, _refinement
#   end
# end
#
# module Godmin
#   module Devise
#     class SessionsController < Godmin::ApplicationController
#       include_refined(::Devise::DeviseController)
#       include_refined(::Devise::SessionsController)
#       layout "godmin/devise"
#     end
#   end
# end

# module Godmin
#   module Devise
#     class SessionsController < Godmin::ApplicationController #< ::Devise::SessionsController
#       layout "godmin/devise"
#
#       def new
#         ::Devise::SessionsController.action("new").call(env)
#       end
#     end
#   end
# end

module Godmin
  module Devise
    class SessionsController < ::Devise::SessionsController
      layout "godmin/devise"
    end
  end
end

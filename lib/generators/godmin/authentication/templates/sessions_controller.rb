<% if namespaced? -%>
require_dependency "<%= File.join(namespaced_path, "application_controller") %>"

<% end -%>
<% module_namespacing do -%>
class SessionsController < ApplicationController
  include Godmin::Authentication::Sessions
end
<% end -%>

<% if namespaced? -%>
require_dependency "<%= File.join(namespaced_path, "application_controller") %>"

<% end -%>
<% module_namespacing do -%>
class <%= class_name.pluralize %>Controller < ApplicationController
  include Godmin::Resources::ResourceController
end
<% end -%>

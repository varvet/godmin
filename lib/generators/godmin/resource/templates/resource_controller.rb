<% if namespaced? -%>
require_dependency "<%= File.join(namespaced_path, "application_controller") %>"

<% end -%>
<% module_namespacing do -%>
class <%= class_name.pluralize %>Controller < ApplicationController
  include Godmin::Resource

  def attrs_for_index
    <%= @attributes.map(&:to_sym) %>
  end

  def attrs_for_form
    <%= @attributes.map(&:to_sym) %>
  end
end
<% end -%>

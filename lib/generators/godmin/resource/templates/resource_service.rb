<% module_namespacing do -%>
class <%= class_name %>Service
  include Godmin::Resources::ResourceService

  attrs_for_index <%= @attributes.map { |x| ":#{x}" }.join(", ") %>
  attrs_for_show <%= @attributes.map { |x| ":#{x}" }.join(", ") %>
  attrs_for_form <%= @attributes.map { |x| ":#{x}" }.join(", ") %>
end
<% end -%>

class Godmin::ResourceController < Godmin::ApplicationController
  inherit_resources
  load_and_authorize_resource

  before_action :prepend_resource_view_paths

  helper_method :attrs_for_index
  helper_method :attrs_for_form
  helper_method :scope_map
  helper_method :batch_process_map
  helper_method :filter_map

  # Initializes the scope map
  def self.scope_map
    @scope_map ||= {}
  end

  # Macro method for defining a scope
  def self.has_scope(attr, options = {})
    defaults = {
      label: attr.to_s.titlecase
    }
    scope_map[attr] = defaults.merge(options)
  end

  # Initializes the batch process map
  def self.batch_process_map
    @batch_process_map ||= {}
  end

  # Macro method for defining a batch process
  def self.batch_processes(attr, options = {})
    defaults = {
      label: attr.to_s.titlecase
    }
    batch_process_map[attr] = defaults.merge(options)
  end

  # Initializes the filter map
  def self.filter_map
    @filter_map ||= {}
  end

  # Macro method for defining a filter
  def self.filters(attr, options = {})
    defaults = {
      as: :string
    }
    filter_map[attr] = defaults.merge(options)
  end

  # Gives the view access to the list of column names
  # to be printed in the index view
  def attrs_for_index
    []
  end

  # Gives the view access to the list of attributes
  # to be included in the default form
  def attrs_for_form
    []
  end

  # Gives the view access to the scope map
  def scope_map
    self.class.scope_map
  end

  # Gives the view access to the batch process map
  def batch_process_map
    self.class.batch_process_map
  end

  # Gives the view access to the filter map
  def filter_map
    self.class.filter_map
  end

  # All batch actions are routed to this action
  def batch_action
    action = params[:batch_process][:action]
    items = params[:batch_process][:items]

    if items
      if batch_process_map.key?(action.to_sym)
        self.send("batch_process_#{action}", resource_class.find(items.keys))
      end
    end

    redirect_to [:admin, resource_class]
  end

  protected

  def collection
    @collection = end_of_association_chain.page(params[:page])

    apply_scope params[:scope] if params[:scope]
    apply_filters params[:filter] if params[:filter]
    apply_order params[:order] if params[:order]

    @collection
  end

  def apply_scope(scope)
    if @collection.methods.include?(scope.to_sym)
      @collection = @collection.send(scope.to_sym)
    end
  end

  def apply_filters(filters)
    filters.each do |name, value|
      if value.present? && filter_map.key?(name.to_sym)
        @collection = self.send("filter_#{name}", @collection, value)
      end
    end
  end

  def apply_order(order)
    order = order.split('_')
    direction = order.pop
    column = order.join('_')

    @collection = @collection.order("#{column} #{direction}")
  end

  private

  def prepend_resource_view_paths
     prepend_view_path "app/views/admin/resource"
     prepend_view_path "app/views/admin/#{resource_class.to_s.underscore.pluralize}"
  end
end

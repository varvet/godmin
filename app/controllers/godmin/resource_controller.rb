module Godmin
  class ResourceController < ApplicationController
    inherit_resources

    concerning :BatchProcessing do
      included do
        helper_method :batch_process_map

        # Initializes the batch process map
        def self.batch_process_map
          @batch_process_map ||= {}
        end

        # Macro method for defining a batch process
        def self.batch_processes(attr, options = {})
          defaults = {
            label: attr.to_s.titlecase,
            only: nil,
            except: nil,
            confirm: false
          }
          batch_process_map[attr] = defaults.merge(options)
        end

        # Gives the view access to the batch process map
        def batch_process_map
          self.class.batch_process_map
        end
      end
    end

    concerning :Filters do
      included do
        helper_method :filter_map

        # Initializes the filter map
        def self.filter_map
          @filter_map ||= {}
        end

        # Macro method for defining a filter
        def self.filters(attr, options = {})
          defaults = {
            label: resource_class.human_attribute_name(attr),
            as: :string,
            option_text: "to_s",
            option_value: "id",
            collection: nil
          }
          filter_map[attr] = defaults.merge(options)
        end

        # Gives the view access to the filter map
        def filter_map
          self.class.filter_map
        end
      end
    end

    concerning :Scopes do
      included do
        helper_method :scope_map

        # Initializes the scope map
        def self.scope_map
          @scope_map ||= {}
        end

        # Macro method for defining a scope
        def self.scopes(attr, options = {})
          defaults = {
            label: attr.to_s.titlecase,
            default: false
          }
          scope_map[attr] = defaults.merge(options)
        end

        # Gives the view access to the scope map
        def scope_map
          self.class.scope_map
        end
      end
    end

    helper_method :attrs_for_index
    helper_method :attrs_for_form

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





    # # All batch actions are routed to this action
    # def batch_action
    #   action = params[:batch_process][:action]
    #   items = params[:batch_process][:items]

    #   authorize! "batch_process_#{action}".to_sym, resource_class

    #   if items
    #     if batch_process_map.key?(action.to_sym)
    #       # Store the batched item ids so they can be highlighted later
    #       flash[:highlight_ids] = items.keys

    #       # If the batch action returns false, it is because it has implemented
    #       # its own redirect. Therefore we return wihout redirecting.
    #       return unless self.send("batch_process_#{action}", resource_class.find(items.keys))
    #     end
    #   end

    #   redirect_to :back
    # end

    # protected

    # def collection
    #   @collection = end_of_association_chain

    #   @collection = apply_default_scope unless params[:scope]
    #   @collection = apply_scope params[:scope] if params[:scope]
    #   @collection = apply_filters params[:filter] if params[:filter]
    #   @collection = apply_order params[:order] if params[:order]
    #   @collection = apply_pagination params[:page]

    #   @collection
    # end

    # def apply_default_scope
    #   collection = @collection

    #   if default_scope
    #     # params[:scope] = default_scope
    #     collection = apply_scope default_scope
    #   else
    #     # params[:scope] = 'all'
    #     # collection = collection.all
    #   end

    #   collection
    # end

    # def apply_scope(scope)
    #   collection = @collection

    #   scope_method = "scope_#{scope}".to_sym

    #   if self.respond_to?(scope_method, true)
    #     collection = self.send(scope_method, collection)
    #   elsif scope_map.key?(scope.to_sym)
    #     collection = collection.send(scope.to_sym)
    #   end

    #   collection
    # end

    # def apply_filters(filters)
    #   collection = @collection

    #   filters.each do |name, value|
    #     if value.present? && filter_map.key?(name.to_sym)
    #       collection = self.send("filter_#{name}", collection, value)
    #     end
    #   end

    #   collection
    # end

    # def apply_order(order)
    #   order = order.split('_')
    #   direction = order.pop
    #   column = order.join('_')

    #   @collection.order("#{resource_class.table_name}.#{column} #{direction}")
    # end

    # def apply_pagination(page)
    #   @collection.page(page)
    # end

    # # Extracts the default scope from the scope map
    # def default_scope
    #   scope = scope_map.find do |k,v|
    #     v[:default]
    #   end

    #   scope ? scope[0] : nil
    # end






    # before_action :prepend_resource_view_paths

    # private

    # def prepend_resource_view_paths
    #    prepend_view_path "app/views/admin/resource"
    #    prepend_view_path "app/views/admin/#{resource_class.to_s.underscore.pluralize}"
    # end
  end
end

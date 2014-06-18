module Godmin
  class ResourceController < ApplicationController
    inherit_resources
    # defaults route_prefix: nil # TODO: this doesn't work for some reason... issue filed

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

        # All batch actions are routed to this action
        def batch_process
          action   = params[:batch_process][:action]
          item_ids = params[:batch_process][:items].keys.map(&:to_i)

          if batch_process_map.key?(action.to_sym)
            # Store the batched item ids so they can be highlighted later
            flash[:batch_processed_ids] = item_ids

            # If the batch action returns false, it is because it has implemented
            # its own redirect. Therefore we return wihout redirecting.
            return unless send("batch_process_#{action}", resource_class.find(item_ids))
          end

          redirect_to :back
        end
      end
    end

    concerning :Filters do
      included do
        helper_method :filter_map

        def self.filter_map
          @filter_map ||= {}
        end

        # Macro method for defining a filter
        def self.filters(attr, options = {})
          defaults = {
            as: :string,
            option_text: "to_s",
            option_value: "id",
            collection: nil
          }
          filter_map[attr] = defaults.merge(options)
        end

        def filter_map
          self.class.filter_map
        end

        def apply_filters(collection)
          if params[:filter].present?
            params[:filter].each do |name, value|
              if filter_map.key?(name.to_sym) && value.present?
                collection = send("filter_#{name}", collection, value)
              end
            end
          end
          collection
        end
      end
    end

    concerning :Scopes do
      included do
        helper_method :scope_map

        def self.scope_map
          @scope_map ||= {}
        end

        # Macro method for defining a scope
        def self.scopes(attr, options = {})
          defaults = {
            default: false
          }
          scope_map[attr] = defaults.merge(options)
        end

        def scope_map
          self.class.scope_map
        end

        def apply_scope(collection)
          if params[:scope].blank?
            params[:scope] = default_scope
          end

          if params[:scope] && scope_map.key?(params[:scope].to_sym)
            if respond_to?("scope_#{params[:scope]}", true)
              send("scope_#{params[:scope]}", collection)
            else
              collection.send(params[:scope]) # TODO: should we even support this?
            end
          else
            collection
          end
        end

        protected

        def default_scope
          scope = scope_map.find -> { scope_map.first } do |k, v|
            v[:default] == true
          end

          scope ? scope[0].to_s : nil
        end
      end
    end

    concerning :Ordering do
      def apply_order(collection)
        if params[:order].present?
          collection.order("#{resource_class.table_name}.#{order_column} #{order_direction}")
        else
          collection
        end
      end

      protected

      def order_column
        params[:order].rpartition("_").first
      end

      def order_direction
        params[:order].rpartition("_").last
      end
    end

    concerning :Pagination do
      def apply_pagination(collection)
        collection.page(params[:page])
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

    def collection
      apply_pagination(
        apply_order(
          apply_filters(
            apply_scope(super)
          )
        )
      )
    end

    protected

    def permitted_params
      params.permit(resource_class.name.downcase => attrs_for_form)
    end

  end
end

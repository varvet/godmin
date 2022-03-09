require "pundit"
require "godmin/authorization/policy"

module Godmin
  module Authorization
    extend ActiveSupport::Concern

    include Pundit::Authorization

    included do
      rescue_from Pundit::NotAuthorizedError do
        render plain: "You are not authorized to do this", status: 403, layout: "godmin/login"
      end
    end

    def policy(record)
      policies[record] ||= Pundit.policy!(pundit_user, namespaced_record(record))
    end

    def pundit_user
      admin_user
    end

    def namespaced_record(record)
      return record unless engine_wrapper.namespaced?

      class_name = find_class_name(record)
      if already_namespaced?(class_name)
        record
      else
        engine_wrapper.namespaced_path.map(&:to_sym) << record
      end
    end

    # Borrowed from Pundit::PolicyFinder
    def find_class_name(subject)
      if subject.respond_to?(:model_name)
        subject.model_name
      elsif subject.class.respond_to?(:model_name)
        subject.class.model_name
      elsif subject.is_a?(Class)
        subject
      elsif subject.is_a?(Symbol)
        subject.to_s.camelize
      else
        subject.class
      end
    end

    def already_namespaced?(subject)
      subject.to_s.start_with?("#{engine_wrapper.namespace.name}::")
    end
  end
end

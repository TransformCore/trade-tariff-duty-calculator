module Wizard
  module Steps
    class BaseController < ::ApplicationController
      default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

      before_action :assign_commodity

      def assign_commodity
        @commodity = Commodity.new(
          code: commodity_code,
          service: service_choice,
        )
      end

      def user_session
        @user_session ||= UserSession.new(session)
      end

      protected

      def commodity_code
        params[:commodity_code]
      end

      def service_choice
        params[:service_choice].to_sym
      end
    end
  end
end

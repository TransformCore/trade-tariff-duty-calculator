module Steps
  class DocumentCodesController < BaseController
    def show
      @step = Steps::DocumentCode.new(user_session, measure_type_id)
    end

    def create
      @step = Steps::DocumentCode.new(user_session, permitted_params)

      validate(@step)
    end

    private

    def permitted_params
      params.require(:steps_document_code).permit(
        document_code_uk: [],
        document_code_xi: [],
      ).merge(measure_type_id)
    end

    def measure_type_id
      params.permit(:measure_type_id)
    end
  end
end

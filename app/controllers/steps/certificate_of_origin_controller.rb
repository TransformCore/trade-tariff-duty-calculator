module Steps
  class CertificateOfOriginController < BaseController
    def show
      @step = Steps::CertificateOfOrigin.new(user_session)
    end

    def create
      @step = Steps::CertificateOfOrigin.new(user_session, permitted_params)

      validate(@step)
    end

    private

    def permitted_params
      params.require(:steps_certificate_of_origin).permit(
        :certificate_of_origin,
      )
    end
  end
end

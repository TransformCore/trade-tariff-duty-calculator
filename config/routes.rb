Rails.application.routes.draw do
  root to: proc { [404, {}, ['Not found.']] }

  scope path: '/duty-calculator/:referred_service/:commodity_code/' do
    get 'import-date', to: 'steps/import_date#show'
    post 'import-date', to: 'steps/import_date#create'
  end

  scope path: '/duty-calculator/' do
    get 'ping', to: 'healthcheck#ping'
    get 'healthcheck', to: 'healthcheck#healthcheck'

    get 'import-destination', to: 'steps/import_destination#show'
    post 'import-destination', to: 'steps/import_destination#create'

    get 'country-of-origin', to: 'steps/country_of_origin#show'
    post 'country-of-origin', to: 'steps/country_of_origin#create'

    get 'customs-value', to: 'steps/customs_value#show'
    post 'customs-value', to: 'steps/customs_value#create'

    get 'trader-scheme', to: 'steps/trader_scheme#show'
    post 'trader-scheme', to: 'steps/trader_scheme#create'

    get 'final-use', to: 'steps/final_use#show'
    post 'final-use', to: 'steps/final_use#create'

    get 'certificate-of-origin', to: 'steps/certificate_of_origin#show'
    post 'certificate-of-origin', to: 'steps/certificate_of_origin#create'

    get 'planned-processing', to: 'steps/planned_processing#show'
    post 'planned-processing', to: 'steps/planned_processing#create'

    get 'measure-amount', to: 'steps/measure_amount#show'
    post 'measure-amount', to: 'steps/measure_amount#create'

    get 'vat', to: 'steps/vat#show'
    post 'vat', to: 'steps/vat#create'

    get 'confirm', to: 'steps/confirmation#show'

    get 'interstitial', to: 'steps/interstitial#show'

    get 'duty', to: 'steps/duty#show'

    get 'additional-codes/:measure_type_id', to: 'steps/additional_codes#show', as: 'additional_codes'
    post 'additional-codes/:measure_type_id', to: 'steps/additional_codes#create'

    get 'document-codes/:measure_type_id', to: 'steps/document_codes#show', as: 'documents'
    post 'document-codes/:measure_type_id', to: 'steps/document_codes#create'
  end

  get '404', to: 'errors#not_found', via: :all
  get '422', to: 'errors#unprocessable_entity', via: :all
  get '500', to: 'errors#internal_server_error', via: :all
end

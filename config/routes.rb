Rails.application.routes.draw do
  root to: proc { [404, {}, ['Not found.']] }

  scope path: '/duty-calculator/:referred_service/:commodity_code/' do
    get 'import-date', to: 'wizard/steps/import_date#show'
    post 'import-date', to: 'wizard/steps/import_date#create'
  end

  scope path: '/duty-calculator/' do
    get 'import-destination', to: 'wizard/steps/import_destination#show'
    post 'import-destination', to: 'wizard/steps/import_destination#create'

    get 'country-of-origin', to: 'wizard/steps/country_of_origin#show'
    post 'country-of-origin', to: 'wizard/steps/country_of_origin#create'

    get 'customs-value', to: 'wizard/steps/customs_value#show'
    post 'customs-value', to: 'wizard/steps/customs_value#create'

    get 'trader-scheme', to: 'wizard/steps/trader_scheme#show'
    post 'trader-scheme', to: 'wizard/steps/trader_scheme#create'

    get 'final-use', to: 'wizard/steps/final_use#show'
    post 'final-use', to: 'wizard/steps/final_use#create'

    get 'certificate-of-origin', to: 'wizard/steps/certificate_of_origin#show'
    post 'certificate-of-origin', to: 'wizard/steps/certificate_of_origin#create'

    get 'planned-processing', to: 'wizard/steps/planned_processing#show'
    post 'planned-processing', to: 'wizard/steps/planned_processing#create'

    get 'measure-amount', to: 'wizard/steps/measure_amount#show'
    post 'measure-amount', to: 'wizard/steps/measure_amount#create'

    get 'confirm', to: 'wizard/steps/confirmation#show'

    get 'trade-remedies', to: 'pages#trade_remedies'

    get 'duty', to: 'wizard/steps/duty#show'
  end

  get 'ping', to: 'healthcheck#ping'

  get '404', to: 'errors#not_found', via: :all
  get '422', to: 'errors#unprocessable_entity', via: :all
  get '500', to: 'errors#internal_server_error', via: :all
end

FactoryBot.define do
  factory :certificate_of_origin, class: 'Steps::CertificateOfOrigin', parent: :step do
    transient { possible_attributes { { certificate_of_origin: 'certificate_of_origin' } } }

    certificate_of_origin { '' }
  end
end

FactoryBot.define do
  factory :import_date, class: 'Steps::ImportDate', parent: :step do
    transient do
      possible_attributes do
        {
          day: 'import_date(3i)',
          month: 'import_date(2i)',
          year: 'import_date(1i)',
        }
      end

      day { '' }
      month { '' }
      year { '' }
    end
  end
end

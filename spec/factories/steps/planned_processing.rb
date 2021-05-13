FactoryBot.define do
  factory :planned_processing, class: 'Wizard::Steps::PlannedProcessing', parent: :step do
    transient do
      possible_attributes { { planned_processing: 'planned_processing' } }
    end

    planned_processing { '' }
  end
end

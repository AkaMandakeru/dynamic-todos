FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence(word_count: 3) }
    completed { false }
    parent_id { nil }

    trait :completed do
      completed { true }
    end

    trait :with_subtasks do
      after(:create) do |todo|
        create_list(:todo, 3, parent_id: todo.id)
      end
    end

    factory :subtask do
      parent_id { create(:todo).id }
    end
  end
end

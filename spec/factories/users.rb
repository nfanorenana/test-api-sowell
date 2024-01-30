FactoryBot.define do
  factory :user, aliases: [:author] do
    fname { Faker::Name.first_name }
    lname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "123456" }
    one_time_password { "123otp" }
    status { :active }
    last_connection_at { DateTime.now.in_time_zone("UTC") - 1.day }

    factory :admin do
      after(:create) do |user|
        user.add_role!(:admin)
      end
    end

    factory :superadmin do
      after(:create) do |user|
        user.add_role!(:superadmin)
      end
    end

    factory :manager do
      after(:create) do |user|
        user.add_role!(:manager, create(:sector, company: user.company))
      end
    end

    factory :reporter do
      after(:create) do |user|
        user.add_role!(:reporter, create(:sector, company: user.company))
      end
    end
  end
end

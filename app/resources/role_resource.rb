class RoleResource < ApplicationResource
  attribute :name, :string
  attribute :sector_id, :integer
  belongs_to :user
  belongs_to :sector

  filter :user_id, :integer do
    eq do |roles, value|
      roles.where(user_id: value)
    end
  end

  filter :reporter_id, :integer do
    eq do |roles, value|
      roles.where(user_id: value, name: :reporter)
    end
  end

  filter :manager_id, :integer do
    eq do |roles, value|
      roles.where(user_id: value, name: :manager)
    end
  end
end

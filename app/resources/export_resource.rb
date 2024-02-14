class ExportResource < ApplicationResource
  attribute :name, :string
  attribute :status, :integer, allow: Export.statuses.keys
  attribute :url, :string
  attribute :params, :jsonb
  attribute :author_id, :integer

  belongs_to :author, resource: UserResource

  before_save do |model|
    model.author_id = current_user.id
  end
end

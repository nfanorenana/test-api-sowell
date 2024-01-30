# frozen_string_literal: true

class UserResource < ApplicationResource
  attribute :fname, :string
  attribute :lname, :string
  attribute :email, :string
  attribute :roles_count, :integer
  attribute :full_name, :string
  attribute :password, :string, only: [:writable]
  attribute :company_id, :integer
  attribute :status, :string_enum, allow: User.statuses.keys
  attribute :recipients, :array

  belongs_to :company
  has_many :issue_reports, foreign_key: :author_id
end

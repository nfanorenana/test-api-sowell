# frozen_string_literal: true

class CompanyResource < ApplicationResource
  attribute :name, :string
  attribute :logo_url, :string
  attribute :logo_base64, :string

  has_many :agencies
  has_many :residences
  has_many :places
  has_many :location_types
  has_many :issue_types
  has_many :users
  has_many :issue_reports
  has_many :sectors
end

module CompanyValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :name, uniqueness: { case_sensitive: false }
  end
end

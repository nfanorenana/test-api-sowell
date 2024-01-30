module AgencyValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
  end
end

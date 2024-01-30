module LocationTypeValidatable
  extend ActiveSupport::Concern
  included do
    validates :company, presence: true
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :nature, presence: true
  end
end

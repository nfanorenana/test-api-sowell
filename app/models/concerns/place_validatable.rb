module PlaceValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :zip, presence: { message: I18n.t("validations.place.zip_presence") }
    validates :city, presence: { message: I18n.t("validations.place.city_presence") }
    validates :country, presence: { message: I18n.t("validations.place.country_presence") }
  end
end

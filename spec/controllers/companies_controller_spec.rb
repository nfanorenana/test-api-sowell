require "spec_helper"
require "rails_helper"

RSpec.describe CompaniesController, type: :request do
  context "a superadmin" do
    let!(:company) { create(:company) }
    let(:superadmin) { create(:superadmin) }

    it "list companies" do
      get companies_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:companies)
      expect(collection["data"].size).to eq(1)
    end

    it "create company" do
      company = build(:company)

      expect {
        post companies_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "companies",
                 attributes: {
                   name: company.name,
                 },
               },
             }
      }.to change { Company.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:companies)
      expect(resource["data"]).to have_attribute(:name).with_value(company.name)
    end

    it "show company" do
      get company_url(company), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(company.name)
    end

    it "update company" do
      newCompany = build(:company)

      patch company_url(company),
            headers: authorization_header(superadmin),
            params: {
              data: {
                id: company.id,
                type: "companies",
                attributes: {
                  name: newCompany.name,
                  logo_url: newCompany.logo_url,
                  logo_base64: newCompany.logo_url,
                },
              },
            }

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(newCompany.name)
    end

    it "destroy company" do
      expect {
        delete company_url(company), headers: authorization_header(superadmin)
      }.to change { Company.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

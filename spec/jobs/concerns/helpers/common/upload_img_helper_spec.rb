require "rails_helper"
include Helpers::Common::UploadImgHelper
RSpec.describe Helpers::Common::UploadImgHelper, type: :concern do
  describe "#upload_img_to_cloudinary" do
    let(:company) { create(:company) }
    let(:cloudinary_cloud_name) { ENV.fetch("CLOUDINARY_CLOUD_NAME", nil) }

    before do
      stub_request(:post,
                   "https://api.cloudinary.com/v1_1/#{cloudinary_cloud_name}/image/upload").to_return(body: { secure_url: "fake_url" }.to_json)
    end

    it "works with a valid image" do
      company.logo_base64 = "data:image/jpeg;base64,/9j/123456"
      company.save!
      logo_url = upload_img_to_cloudinary(company.logo_base64, "ci", company.id.to_s)
      expect(logo_url).to eq("fake_url")
    end

    it "doesn't work with an invalid image" do
      expect do
        upload_img_to_cloudinary(company.logo_base64, "ci", company.id.to_s)
      end.to raise_error("not a valid image")
    end
  end
end

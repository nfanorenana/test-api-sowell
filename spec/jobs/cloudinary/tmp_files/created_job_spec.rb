require "rails_helper"

RSpec.describe Cloudinary::TmpFiles::CreatedJob, type: :job do
  describe "#perform" do
    let!(:issue_report) { create(:issue_report) }
    let!(:tmp_file) { create(:tmp_file, resource_id: issue_report.id) }
    let(:cloudinary_cloud_name) { ENV.fetch("CLOUDINARY_CLOUD_NAME", nil) }
    let(:body) { { secure_url: "fake_url.jpeg" } }
    let(:cloudinary_url) { "https://api.cloudinary.com/v1_1/#{cloudinary_cloud_name}/image/upload" }
    let(:headers) { { "Content-Type" => %r{multipart/form-data} } }
    before do
      stub_request(:post, cloudinary_url)
        .with(
          headers: headers
        ).to_return(status: 200, body: body.to_json)
      Cloudinary::TmpFiles::CreatedJob.new.perform(tmp_file.id, "ii_v2")
    end

    it "send the expected request to Cloudinary" do
      assert_requested :post,
                       cloudinary_url,
                       times: 1,
                       headers: headers

      expect(IssueReport.last.imgs).to eq(["fake_url.jpeg"])
    end
  end
end

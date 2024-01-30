require 'rails_helper'

RSpec.describe Postmark::Auth::SendOtpJob, :type => :job do
  describe "#perform" do
    let(:user) { 
      user = create(:user)
      user.one_time_password = SecureRandom.hex(3)
      user.save!
      user
    }
    let(:postmark_url) { ENV['POSTMARK_URL'] }
    let(:template_id) { ENV['POSTMARK_PASSWORD_RECOVERY_TEMPLATE_V2'] }
    let(:body) {
      {
        From: 'support@sowellapp.com',
        To: user.email,
        TemplateId: template_id,
        TemplateModel: {
          user_reset_otp: user.one_time_password
        }
      }
    }
    before {
      stub_request(:post, postmark_url)
        .with(
          body: body.to_json
        ).to_return(status: 200)

      Postmark::Auth::SendOtpJob.new.perform(user.email, user.one_time_password)
    }
    it "send the expected request to Postmark" do
      assert_requested :post, postmark_url, times: 1, body: body
    end
  end
end
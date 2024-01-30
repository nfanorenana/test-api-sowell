require "rails_helper"

RSpec.describe ApplicationController do
  subject { ApplicationController }

  describe "::include" do
    it { is_expected.to include(Tokenable) }
    it { is_expected.to include(Rescueable) }
  end
end

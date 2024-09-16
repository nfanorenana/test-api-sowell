require 'rails_helper'

RSpec.describe VisitProp, type: :model do
  let(:company) { create(:company) }


  let(:base_location_type) { create(:base_location_type, depth_level: 2) }
  let(:location_type) { create(:location_type, base_location_type: base_location_type)}

  let(:base_issue_type)

  let(:company) { create(:company) }
  let(:checklist) { create(:checklist, company: company, location_type: location_type) }
  let(:checkpoint) { create(:checkpoint, checklist: checklist) }

  let(:place) { create(:place, company: company) }
  let!(:visit_prop) { create(:visit_prop, checkpoint: checkpoint, place: place) }

  describe "#default visit_prop" do
    it "is valid" do

      expect(visit_prop).to be_valid
    end
  end
end

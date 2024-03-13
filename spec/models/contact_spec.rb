require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "#create_patient!" do
    let!(:contact) { FactoryBot.create(:contact) }

    it "creates a patient with the same first and last name as the contact and the default avatar URL" do
      expect { contact.create_patient! }.to change(Patient, :count).by(1)
      expect(contact.patient.first_name).to eql(contact.first_name)
      expect(contact.patient.last_name).to eql(contact.last_name)
      expect(contact.patient.avatar_url).to eql(Contact::DEFAULT_AVATAR_URL)
    end

    it "merges defaults with any attributes it gets" do
      contact.create_patient!(last_name: "Cameron")

      expect(contact.patient.first_name).to eql(contact.first_name)
      expect(contact.patient.last_name).to eql("Cameron")
      expect(contact.patient.avatar_url).to eql(Contact::DEFAULT_AVATAR_URL)
    end
  end
end

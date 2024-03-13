require "rails_helper"

RSpec.describe PatientSyncService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  let(:instance) { described_class.new(patient) }
  let(:patient) { FactoryBot.create(:patient, sicklie_id: patient_sicklie_id) }

  describe "#sync" do
    subject(:call) { instance.sync }

    before { freeze_time }

    shared_examples "raises exceptions on errors" do
      describe "error handling" do
        before do
          allow(SicklieApi).to receive(:create_patient).and_return api_response
        end

        context "when Sicklie response is not a hash" do
          let(:api_response) { "Internal server error" }

          it "throws an error containing the message" do
            expect { call }.to raise_error PatientSyncService::SyncError, 
              "Error syncing with Sicklie: Internal server error"
          end
        end

        context "when Sicklie response has status code other than 'SUCCESS'" do
          let(:api_response) do
            {status_code: "FIELD_ERROR", field: "last_name", message: "Sorry, we don't like this last name right now" }
          end

          it "throws an error with the status message" do
            expect { call }.to raise_error PatientSyncService::SyncError, "Error syncing with Sicklie: #{api_response}"
          end
        end
      end
    end

    context "when the patient does NOT have a sicklie_id" do
      let(:patient_sicklie_id) { nil }
      let(:api_response) do
        { status_code: "SUCCESS", sicklie_id: SecureRandom.uuid }
      end

      before { allow(SicklieApi).to receive(:create_patient).and_return(api_response) }

      it "calls the sicklie API to create a patient" do
        call
        expect(SicklieApi).to have_received(:create_patient).with(
          first_name: patient.first_name,
          last_name: patient.last_name,
        )
      end

      it "updates the patient record" do
        call
        expect(patient).to have_attributes(
          sicklie_id: api_response[:sicklie_id],
          sicklie_updated_at: Time.current          
        )
      end

      it_behaves_like "raises exceptions on errors"
    end

    context "when the patient has a sicklie_id" do
      let(:patient_sicklie_id) { SecureRandom.uuid }
      let(:api_response) do
        { status_code: "SUCCESS", sicklie_id: SecureRandom.uuid }
      end

      before { allow(SicklieApi).to receive(:update_patient).and_return(api_response) }

      it "calls the sicklie API to update a patient" do
        call
        expect(SicklieApi).to have_received(:update_patient).with(
          sicklie_id: patient_sicklie_id,
          first_name: patient.first_name,
          last_name: patient.last_name,
        )
      end

      it "updates the patient record" do
        call
        expect(patient).to have_attributes(
          sicklie_updated_at: Time.current          
        )
      end

      it_behaves_like "raises exceptions on errors"
    end    
  end
end
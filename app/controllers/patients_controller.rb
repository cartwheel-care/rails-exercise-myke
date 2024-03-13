class PatientsController < ApplicationController
  rescue_from PatientSyncService::SyncError, with: :flash_sync_error
  
  def index
    @patients = Patient.all.order(:first_name, :last_name)
  end

  def create
    patient = Contact.find(params[:contact_id]).create_patient!

    flash[:info] = "Created patient '#{patient.first_name} #{patient.last_name}' with Sicklie"

    redirect_to controller: :contacts, action: :index
  end

  def sync
    @patient = Patient.find(params[:id])

    PatientSyncService.new(@patient).sync

    flash[:info] = "Synced patient '#{@patient.first_name} #{@patient.last_name}' with Sicklie"
    redirect_to action: :index
  end

  private

  def flash_sync_error(error)
    flash[:danger] = error.message
    redirect_to action: :index
  end
end

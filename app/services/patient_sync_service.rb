class PatientSyncService
  def initialize(patient)
    @patient = patient
  end

  def sync
    if @patient.sicklie_id.blank?
      create_patient
    else
      update_patient
    end
  end

  private

  def create_patient
    result = SicklieApi.create_patient(
      first_name: @patient.first_name, 
      last_name: @patient.last_name
    )

    handle_result(result)
  end

  def update_patient
    result = SicklieApi.update_patient(
      sicklie_id: @patient.sicklie_id, 
      first_name: @patient.first_name, 
      last_name: @patient.last_name
    )

    handle_result(result)
  end

  def handle_result(result)
    if result.is_a?(Hash) && result[:status_code] == "SUCCESS"
      attributes = { sicklie_updated_at: Time.current }
      
      if sicklie_id = result[:sicklie_id]
        attributes[:sicklie_id] = sicklie_id
      end
      
      @patient.update!(attributes)
    else
      raise SyncError, result
    end
  end
  
  class SyncError < StandardError
    def initialize(result)
      super("Error syncing with Sicklie: #{result}")
    end
  end
end
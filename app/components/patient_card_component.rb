class PatientCardComponent < ViewComponent::Base
  def initialize(patient)
    @patient = patient
  end
end
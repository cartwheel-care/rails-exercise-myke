class ContactCardComponent < ViewComponent::Base
  def initialize(contact)
    @contact = contact
  end
end
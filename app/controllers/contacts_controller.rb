class ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:patient).all.order(:first_name, :last_name)
  end
end

class Patient < ApplicationRecord
  has_one :contact, autosave: true
end

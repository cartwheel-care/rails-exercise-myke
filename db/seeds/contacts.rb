10.times do
  FactoryBot.create(:contact)
end

5.times do
  FactoryBot.create(:contact, :with_patient)
end
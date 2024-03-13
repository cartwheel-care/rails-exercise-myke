class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :patient, foreign_key: true

      t.timestamps
    end

    add_index :contacts, [:first_name, :last_name]
  end
end

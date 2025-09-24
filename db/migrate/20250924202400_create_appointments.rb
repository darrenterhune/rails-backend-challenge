class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.datetime :deleted_at
      t.references :client, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.references :availability, null: false, foreign_key: true

      t.timestamps
    end

    add_index :appointments, [ :client_id, :provider_id, :availability_id ], unique: true, name: 'index_appointments_on_client_provider_availability'
  end
end

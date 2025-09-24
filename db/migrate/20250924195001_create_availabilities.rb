class CreateAvailabilities < ActiveRecord::Migration[8.0]
  def change
    create_table :availabilities do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :source
      t.references :provider, null: false, foreign_key: true
      t.timestamps
    end
  end
end

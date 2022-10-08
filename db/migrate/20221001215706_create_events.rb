class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :asset_sim, null: false, foreign_key: true
      t.integer :event_type
      t.integer :event_age
      t.integer :event_value
      t.integer :event_term
      t.string :remarks

      t.timestamps
    end
  end
end

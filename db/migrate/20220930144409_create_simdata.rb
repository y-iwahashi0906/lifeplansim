class CreateSimdata < ActiveRecord::Migration[6.1]
  def change
    create_table :simdata do |t|
      t.integer :cash
      t.integer :investment_asset
      t.integer :income
      t.integer :expense
      t.integer :investment_ratio
      t.integer :investment_yield
      t.integer :inflation_ratio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

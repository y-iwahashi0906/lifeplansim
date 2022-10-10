class ChangeDatatypeNameToStringInEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :name, :string
    change_column :events, :description, :text
  end
end

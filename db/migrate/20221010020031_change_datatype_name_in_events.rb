class ChangeDatatypeNameInEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :name, :text
  end
end

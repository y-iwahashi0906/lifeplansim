class ChangeDatatypeBirthInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :birth, :date
  end
end

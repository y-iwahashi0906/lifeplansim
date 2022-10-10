class AddIsvaildToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :isvalid, :boolean, default: true
  end
end

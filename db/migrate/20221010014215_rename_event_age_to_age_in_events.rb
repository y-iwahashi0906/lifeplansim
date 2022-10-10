class RenameEventAgeToAgeInEvents < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :event_type, :name
	  rename_column :events, :event_age, :age
	  rename_column :events, :event_value, :value
	  rename_column :events, :event_term, :term
  end
  
end

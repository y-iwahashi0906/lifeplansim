class ChangeSimdataToAssetSims < ActiveRecord::Migration[6.1]
  def change
    rename_table :simdata, :asset_sims
  end
end

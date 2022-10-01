class ChangeDataInflationRatioToAssetSims < ActiveRecord::Migration[6.1]
  def change
    change_column :asset_sims, :inflation_ratio, :float
  end
end

class ChangeDataInvestmentYieldToAssetSims < ActiveRecord::Migration[6.1]
  def change
    change_column :asset_sims, :investment_yield, :float
  end
end

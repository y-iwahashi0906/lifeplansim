class AssetSimsController < ApplicationController
  def create
    @asset_sim = current_user.asset_sims.build(asset_sim_params)
    if @asset_sim.save
      flash[:success] = 'データ作成に成功しました。'
      redirect_to root_url
    else
      @pagy, @asset_sims = pagy(current_user.asset_sims.order(id: :desc))
      flash[:danger] = 'データ作成に失敗しました。'
      redirect_to root_url #formのsubmitを更新する必要があるため再読み込み
    end
  end
  
  def update
    @asset_sim = current_user.asset_sims.first
    if @asset_sim.update(asset_sim_params)
      flash[:success] = '正常に更新されました'
      
      redirect_to root_url #controller: :ToppagesController,  action: :index
    else
      flash[:danger] = '更新に失敗しました。'
      redirect_to root_url #formのsubmitを更新する必要があるため再読み込み
    end
  end
  
  def destroy
  end
  
  private

  def asset_sim_params
    params.require(:asset_sim).permit(:cash, :investment_asset, :income, :expense, :investment_ratio, :investment_yield, :inflation_ratio)
  end
end

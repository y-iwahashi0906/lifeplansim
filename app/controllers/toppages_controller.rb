class ToppagesController < ApplicationController
  def index
    if logged_in?
      @asset_sim = current_user.asset_sims.find_or_initialize_by( user_id: current_user.id)# form_with 用 #データがない場合の動きを確認する
      @pagy, @asset_sims = pagy(current_user.asset_sims.order(id: :desc))
      @graph_asset = []
      if params[:display] 
        unless @asset_sim.new_record?
          create_graph_asset
        end
      end
    end
  end
  
  private
  
  def create_graph_asset
    age_max = 80
    #設定値で初期値設定
    cash = @asset_sim.cash
    investment_asset = @asset_sim.investment_asset
    income = @asset_sim.income
    expense = @asset_sim.expense
    
    #グラフ描画データ初期化
    @graph_asset = Array.new(0) { Array.new(2,0) } #資産データ
    @graph_asset_cash = Array.new(0) { Array.new(2,0) } #現金
    @graph_investment_asset = Array.new(0) { Array.new(2,0) } #投資資産
    @graph_expense = Array.new(0) { Array.new(2,0) } #年間支出
    
    
    for i in 0 .. (age_max - current_user.age) do
      
      @graph_asset << [(current_user.age + i).to_s, cash + investment_asset]
      @graph_asset_cash << [(current_user.age + i).to_s, cash]
      @graph_investment_asset << [(current_user.age + i).to_s, investment_asset]
      @graph_expense << [(current_user.age + i).to_s, expense]
      
      #年間収支が黒字の場合
      if (income - expense) >= 0
        #投資割合で現金と投資資産を増額
        cash = cash + (income - expense) * (@asset_sim.investment_ratio.to_f / 100)
        investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100)) + (income - expense) * ((100 - @asset_sim.investment_ratio).to_f / 100)
      #年間収支が赤字の場合
      else
        #現金がある場合は現金からマイナス
        if cash >= 0
          cash = cash + (income - expense)
          investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100)) 
        #現金がない場合は投資資産からマイナス
        else
          investment_asset = investment_asset + (income - expense)
          investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100))
        end
      end
      #インフレ率に応じて年間支出増加
      expense = expense * (1 + (@asset_sim.inflation_ratio / 100))
      i += 1
      
    end
  end
end

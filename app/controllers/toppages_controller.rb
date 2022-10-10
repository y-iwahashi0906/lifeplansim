class ToppagesController < ApplicationController
  def index
    if logged_in?
      @asset_sim = current_user.asset_sims.find_or_initialize_by( user_id: current_user.id) #検索方法はあとで見直し
      @pagy, @asset_sims = pagy(current_user.asset_sims.order(id: :desc))
      
      @graph_asset = []
      @chkbox = {:chk_asset => true, :chk_cash => true, :chk_investment_asset => true, :chk_expense => true}
      unless @asset_sim.new_record?
        @pagy, @events = pagy(@asset_sim.events.order(id: :desc))
        @events = @asset_sim.events.order(id: :desc)
        create_graph_asset
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
    
    if params[:isButtonDown]
      @events.each do |event|
        if params[:isvalid[event.id]] == event.id.to_s
          event.isvalid = true
        else
          event.isvalid = false
        end
        event.update_attribute(:isvalid, event.isvalid)
      end
      
      if params[:chk_asset].to_i == 0
        @chkbox[:chk_asset] = false
      else
        @chkbox[:chk_asset] = true
      end
      if params[:chk_cash].to_i == 0
        @chkbox[:chk_cash] = false
      else
        @chkbox[:chk_cash] = true
      end
      if params[:chk_investment_asset].to_i == 0
        @chkbox[:chk_investment_asset] = false
      else
        @chkbox[:chk_investment_asset] = true
      end
      if params[:chk_expense].to_i == 0
        @chkbox[:chk_expense] = false
      else
        @chkbox[:chk_expense] = true
      end
    end
    
    for i in 0 .. (age_max - current_user.age) do
      
      inc_income = 0
      inc_expense = 0
      
      @events.each do |event|
        if event.isvalid
          if event.age <= current_user.age + i && current_user.age + i < event.age + event.term
            if event.value >= 0
              inc_income =inc_income + event.value
            else
              inc_expense =  inc_expense - event.value
            end
          end
        end
      end
      
      annual_balance = income + inc_income - expense - inc_expense
      
      if @chkbox[:chk_asset]
        @graph_asset << [(current_user.age + i).to_s, cash + investment_asset]
      end
      if @chkbox[:chk_cash]
        @graph_asset_cash << [(current_user.age + i).to_s, cash]
      end
      if @chkbox[:chk_investment_asset]
        @graph_investment_asset << [(current_user.age + i).to_s, investment_asset]
      end
      if @chkbox[:chk_expense]
        @graph_expense << [(current_user.age + i).to_s, expense + inc_expense]
      end
      
      #年間収支が黒字の場合
      if (annual_balance) >= 0
        #投資割合で現金と投資資産を増額
        cash = cash + (annual_balance) * (@asset_sim.investment_ratio.to_f / 100)
        investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100)) + (annual_balance) * ((100 - @asset_sim.investment_ratio).to_f / 100)
      #年間収支が赤字の場合
      else
        #現金がある場合は現金からマイナス
        if cash >= 0
          cash = cash + (annual_balance)
          investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100)) 
        #現金がない場合は投資資産からマイナス
        else
          investment_asset = investment_asset + (annual_balance)
          investment_asset = investment_asset * (1 + (@asset_sim.investment_yield / 100))
        end
      end
      #インフレ率に応じて年間支出増加
      expense = expense * (1 + (@asset_sim.inflation_ratio / 100))
      i += 1
    end
  end
end

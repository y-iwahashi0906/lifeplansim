class ToppagesController < ApplicationController
  def index
    Struct.new("Chkbox", :name, :ischecked)

    if logged_in?
      @asset_sim = current_user.asset_sims.find_or_initialize_by(user_id: current_user.id) #検索方法はあとで見直し
      @pagy, @asset_sims = pagy(current_user.asset_sims.order(id: :desc))

      unless @asset_sim.new_record?
        @pagy, @events = pagy(@asset_sim.events.order(id: :desc))
        @events = @asset_sim.events.order(id: :desc)

        @chkboxes = {
          chk_asset: Struct::Chkbox.new("資産", true),
          chk_cash: Struct::Chkbox.new("現金", true),
          chk_investment_asset: Struct::Chkbox.new("投資資産", true),
          chk_income: Struct::Chkbox.new("年間収入", true),
          chk_expense: Struct::Chkbox.new("年間支出", true),
        }

        create_graph_asset
      end
    end
  end

  private

  def create_graph_asset
    age_max = 80

    #設定値で初期値設定
    @cash = @asset_sim.cash
    @investment_asset = @asset_sim.investment_asset
    @income = @asset_sim.income
    @expense = @asset_sim.expense

    #グラフ描画データ初期化
    @graph = {
      chk_asset: [],
      chk_cash: [],
      chk_investment_asset: [],
      chk_income: [],
      chk_expense: [],
    }

    #実行ボタン押下時のみグラフ表示設定を更新する
    if params[:isButtonDown]
      set_chkbox
    end

    for i in 0..(age_max - current_user.age)
      age = current_user.age + i
      inc_income = 0
      inc_expense = 0

      #年度のイベントの期間中の収支を計算
      @events.each do |event|
        case event.event_type
        when Constants::EVENT_TYPE_CHANGE_INCOME
          if event.isvalid && event.age == age
            @income = event.value
          end
        when Constants::EVENT_TYPE_OTHER
          if event.isvalid && event.age <= age && age < event.age + event.term
            if event.value >= 0
              inc_income = inc_income + event.value
            else
              inc_expense = inc_expense - event.value
            end
          end
        end
      end
      annual_income = @income + inc_income
      annual_expense = @expense - inc_expense

      annual_balance = annual_income - annual_expense

      add_graph(:chk_asset, [age.to_s, @cash + @investment_asset])
      add_graph(:chk_cash, [age.to_s, @cash])
      add_graph(:chk_investment_asset, [age.to_s, @investment_asset])
      add_graph(:chk_income, [age.to_s, annual_income])
      add_graph(:chk_expense, [age.to_s, annual_expense])

      cal_next_year(annual_balance)
      i += 1
    end
  end

  def set_chkbox
    @events.each do |event|
      if params[:isvalid[event.id]] == event.id.to_s
        event.isvalid = true
      else
        event.isvalid = false
      end
      event.update_attribute(:isvalid, event.isvalid)
    end

    @chkboxes.each do |key, chkbox|
      if params[key].to_i == 0
        chkbox.ischecked = false
      else
        chkbox.ischecked = true
      end
    end
  end

  def add_graph(key, value)
    if @chkboxes[key].ischecked
      @graph[key] << value
    end
  end

  def cal_next_year(annual_balance)
    #年間収支が黒字の場合
    if (annual_balance) >= 0
      #投資割合で現金と投資資産を増額
      @cash = @cash + (annual_balance) * (@asset_sim.investment_ratio.to_f / 100)
      @investment_asset = @investment_asset * (1 + (@asset_sim.investment_yield / 100)) + (annual_balance) * ((100 - @asset_sim.investment_ratio).to_f / 100)
      #年間収支が赤字の場合
    else
      #現金があり、年間支出を足してマイナスとならない場合は現金からマイナス
      if @cash + (annual_balance) >= 0
        @cash = @cash + (annual_balance)
        @investment_asset = @investment_asset * (1 + (@asset_sim.investment_yield / 100))
        #現金がない場合は投資資産からマイナス
      elsif @investment_asset + annual_balance >= 0
        @investment_asset = @investment_asset + (annual_balance)
        @investment_asset = @investment_asset * (1 + (@asset_sim.investment_yield / 100))
      else #現金も投資資産もない場合は現金からマイナス
        @cash = @cash + (annual_balance)
      end
    end
    #インフレ率に応じて年間支出増加
    @expense = @expense * (1 + (@asset_sim.inflation_ratio / 100))
  end
end

class EventsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_asset_sim, only: [:edit, :update, :destroy]
  
  def new
    @event = Event.new
  end

  def create
    @asset_sim = current_user.asset_sims.find_by( user_id: current_user.id)
    unless @asset_sim
      redirect_to root_url
    end
    @event = @asset_sim.events.build(event_params)

    if @event.save
      flash[:success] = '正常に設定されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'イベントが設定できませんでした'
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = '正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    flash[:success] = '正常に削除されました'
    redirect_to root_url
  end
  
  
  # Strong Parameter
  def event_params
    params.require(:event).permit(:name, :value, :age, :term, :description, :isvalid)
  end
  
  def correct_asset_sim
    @asset_sim = current_user.asset_sims.find_by(user_id: current_user.id) #検索方法は見直し
    unless @asset_sim
      redirect_to root_url
    end
  end
end

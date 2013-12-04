# -*- encoding : utf-8 -*-
class Network::StagesController < Network::NetworkController
  def index
    @title = 'ეტაპები'
    @stages = Network::Stage.asc(:numb)
  end

  def new
    @title = 'ახალი ეტაპი'
    if request.post?
      @stage = Network::Stage.new(params.require(:network_stage).permit(:name))
      if @stage.save
        Network::Stage.auto_numerate
        redirect_to network_stages_url, notice: 'ეტაპი დამატებულია'
      end
    else
      @stage = Network::Stage.new
    end
  end

  def edit
    @title = 'ეტაპის შეცვლა'
    @stage = Network::Stage.find(params[:id])
    if request.post?
      if @stage.update_attributes(params.require(:network_stage).permit(:name, :numb))
        Network::Stage.auto_numerate
        redirect_to network_stages_url, notice: 'ეტაპი შეცვლილია'
      end
    end
  end

  def delete
    stage = Network::Stage.find(params[:id])
    stage.destroy
    Network::Stage.auto_numerate
    redirect_to network_stages_url, notice: 'ეტაპი წაშლილია'
  end

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ეტაპები' => network_stages_url }
    @nav[@title] = nil if @stage
  end
end

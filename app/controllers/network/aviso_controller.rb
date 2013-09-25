# -*- encoding : utf-8 -*-
class Network::AvisoController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'ავიზოები'
    @search = params[:search] == 'clear' ? nil : params[:search]
    rel = Billing::Aviso
    if @search
      @search[:complete] = @search[:complete] != '0'
      rel = rel.where(basepointkey: @search['paypoint'].to_i) if @search['paypoint'].present?
      rel = rel.where(avdate: Date.strptime(@search['date'])) if @search['date'].present?
      rel = rel.where(status: @search[:complete])
    end
    @avisos = rel.order('avdetkey DESC').paginate(page: params[:page], per_page: 10)
  end

  def show
    @title = 'ავიზოს თვისებები'
    @aviso = Billing::Aviso.find(params[:id])
    @application = @aviso.guessed_application unless @aviso.status
  end

  def link
    aviso = Billing::Aviso.find(params[:id])
    application = aviso.guessed_application
    aviso.status = true
    if aviso.save
      application.aviso_id = aviso.avdetkey
      application.save
    end
    redirect_to network_aviso_url(id: aviso.avdetkey, tab: 'related'), notice: 'განცხადება დაკავშირებულია ავიზოსთან.'
  end

  protected

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ავიზოები' => network_avisos_url }
    if @aviso
      @nav['ავიზოს თვისებები'] = network_aviso_url(id: @aviso.avdetkey)
    end
    @nav
  end
end

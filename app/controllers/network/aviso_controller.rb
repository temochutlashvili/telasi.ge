# -*- encoding : utf-8 -*-
class Network::AvisoController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'ავისოები'
    @search = params[:search] == 'clear' ? nil : params[:search]
    rel = Billing::Aviso
    if @search
      rel = rel.where(basepointkey: @search['paypoint'].to_i) if @search['paypoint'].present?
      rel = rel.where(avdate: Date.strptime(@search['date'])) if @search['date'].present?
    end
    @avisos = rel.order('avdetkey DESC').paginate(page: params[:page], per_page: 10)
  end

  protected

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ავისოები' => network_aviso_url }
    @nav
  end
end

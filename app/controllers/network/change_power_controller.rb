# -*- encoding : utf-8 -*-
class Network::ChangePowerController < Network::NetworkController
  def index
    @title = 'სიმძლავრის შეცვლა'
    @title = 'ქსელზე მიერთება'
    @search = params[:search] == 'clear' ? nil : params[:search]
    rel = Network::ChangePowerApplication
    if @search
      rel = rel.where(number: @search[:number].mongonize) if @search[:number].present?
      rel = rel.where(rs_name: @search[:rs_name].mongonize) if @search[:rs_name].present?
      rel = rel.where(rs_tin: @search[:rs_tin].mongonize) if @search[:rs_tin].present?
      rel = rel.where(status: @search[:status].to_i) if @search[:status].present?
      rel = rel.where(stage: Network::Stage.find(@search[:stage])) if @search[:stage].present?
      rel = rel.where(:send_date.gte => @search[:send_d1]) if @search[:send_d1].present?
      rel = rel.where(:send_date.lte => @search[:send_d2]) if @search[:send_d2].present?
      rel = rel.where(:start_date.gte => @search[:start_d1]) if @search[:start_d1].present?
      rel = rel.where(:start_date.lte => @search[:start_d2]) if @search[:start_d2].present?
      rel = rel.where(:end_date.gte => @search[:end_d1]) if @search[:end_d1].present?
      rel = rel.where(:end_date.lte => @search[:end_d2]) if @search[:end_d2].present?
    end
    @applications = rel.desc(:_id).paginate(page: params[:page_change], per_page: 10)
  end

  def new
    @title = 'ახალი განცხადება'
    if request.post?
      @application = Network::ChangePowerApplication.new(change_power_params)
      @application.user = current_user
      @application.status = Network::NewCustomerApplication::STATUS_SENT
      if @application.save
        redirect_to network_change_power_url(id: @application.id), notice: 'განცხადება შექმნილია.'
      end
    else
      @application = Network::ChangePowerApplication.new
    end
  end

  def show
    @application = Network::ChangePowerApplication.find(params[:id])
    @title = 'განცხადების შეცვლა'
  end

  def edit
    @title = 'განცხადების შეცვლა'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post?
      if @application.update_attributes(change_power_params)
        redirect_to network_change_power_url(id: @application.id), notice: 'განცხადება შეცვლილია.'
      end
    end
  end

  def delete
    application = Network::ChangePowerApplication.find(params[:id])
    application.destroy
    redirect_to network_change_power_applications_url, notice: 'განცხადება წაშლილია.'
  end

  def change_status
    @title = 'სტატუსის ცვლილება'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post?
      @message = Sys::SmsMessage.new(params.require(:sys_sms_message).permit(:message))
      @message.messageable = @application
      @message.mobile = @application.mobile
      if @message.save
        @message.send_sms!
        @application.status = params[:status].to_i
        if @application.save
          redirect_to network_change_power_url(id: @application.id), notice: 'სტატუსი შეცვლილია'
        else
          @error = @application.errors.full_messages
        end
      end
    else
      @message = Sys::SmsMessage.new
    end
  end

  def upload_file
    @title = 'ფაილის ატვირთვა'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post? and params[:sys_file]
      @file = Sys::File.new(params.require(:sys_file).permit(:file))
      if @file.save
        @application.files << @file
        redirect_to network_change_power_url(id: @application.id, tab: 'files'), notice: 'ფაილი დამატებულია'
      end
    else
      @file = Sys::File.new
    end
  end

  def delete_file
    application = Network::ChangePowerApplication.find(params[:id])
    file = application.files.where(_id: params[:file_id]).first
    file.destroy
    redirect_to network_change_power_url(id: application.id, tab: 'files'), notice: 'ფაილი წაშლილია'
  end

  def send_sms
    @title = 'შეტყობინების გაგზავნა'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post?
      @message = Sys::SmsMessage.new(params.require(:sys_sms_message).permit(:message))
      @message.messageable = @application
      @message.mobile = @application.mobile
      if @message.save
        @message.send_sms!
        redirect_to network_change_power_url(id: @application.id, tab: 'sms'), notice: 'შეტყობინება გაგზავნილია'
      end
    else
      @message = Sys::SmsMessage.new
    end
  end

  def new_control_item
    @title = 'ახალი საკონტროლო ჩანაწერი'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post?
      @item = Network::RequestItem.new(params.require(:network_request_item).permit(:type, :date, :description, :stage_id))
      @item.source = @application
      if @item.save
        @application.update_last_request
        redirect_to network_change_power_url(id: @application.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი დამატებულია'
      end
    else
      @item = Network::RequestItem.new(source: @application, date: Date.today)
    end
  end

  def edit_control_item
    @title = 'საკონტროლო ჩანაწერის შეცვლა'
    @item = Network::RequestItem.find(params[:id])
    if request.post?
      if @item.update_attributes(params.require(:network_request_item).permit(:type, :date, :description, :stage_id))
        @item.source.update_last_request
        redirect_to network_change_power_url(id: @item.source.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი შეცვლილია'
      end
    end
  end

  def delete_control_item
    item = Network::RequestItem.find(params[:id])
    app = item.source
    item.destroy
    app.update_last_request
    redirect_to network_change_power_url(id: app.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი წაშლილია'
  end

  def edit_amount
    @title = 'თანხის შეცვლა'
    @application = Network::ChangePowerApplication.find(params[:id])
    if request.post?
      if @application.update_attributes(params.require(:network_change_power_application).permit(:amount))
        redirect_to network_change_power_url(id: @application.id), notice: 'თანხა შეცვლილია'
      end
    end
  end

  def send_factura
    application = Network::ChangePowerApplication.find(params[:id])
    raise 'ფაქტურის გაგზავნა დაუშვებელია' unless application.can_send_factura?
    factura = RS::Factura.new(date: Time.now, seller_id: RS::TELASI_PAYER_ID)
    amount = application.amount
    raise 'თანხა უნდა იყოს > 0' unless amount > 0
    raise 'ფაქტურის გაგზავნა ვერ ხერხდება!' unless RS.save_factura(factura, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, buyer_tin: application.rs_tin))
    vat = application.pays_non_zero_vat? ? amount * (1 - 1.0 / 1.18) : 0
    factura_item = RS::FacturaItem.new(factura: factura, good: 'ქსელში ცვლილებების საფასური', unit: 'მომსახურეობა', amount: amount, vat: vat, quantity: 1)
    RS.save_factura_item(factura_item, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID))
    if RS.send_factura(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
      factura = RS.get_factura_by_id(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
      application.factura_seria = factura.seria
      application.factura_number = factura.number
    end
    application.factura_id = factura.id
    application.save
    redirect_to network_change_power_url(id: application.id, tab: 'factura'), notice: 'ფაქტურა გაგზავნილია :)'
  end

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ქსელში ცვლილება' => network_change_power_applications_url }
    if @application
      if not @application.new_record?
        @nav[ "№#{@application.number}" ] = network_change_power_url(id: @application.id)
        @nav[@title] = nil if action_name != 'show'
      else
        @nav['ახალი განცხადება'] = nil
      end
    end
    @nav
  end

  private

  def change_power_params; params.require(:network_change_power_application).permit(:need_factura, :work_by_telasi, :type, :number, :note, :rs_tin, :vat_options, :mobile, :email, :address, :work_address, :address_code, :bank_code, :bank_account, :voltage, :power, :old_voltage, :old_power, :customer_id) end
end

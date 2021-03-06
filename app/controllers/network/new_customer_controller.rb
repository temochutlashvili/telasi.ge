# -*- encoding : utf-8 -*-
require 'rs'

class Network::NewCustomerController < Network::NetworkController
  def index
    @title = 'ახალი აბონენტი'
    @search = params[:search] == 'clear' ? nil : params[:search]
    rel = Network::NewCustomerApplication
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
      rel = rel.where(:plan_end_date.gte => @search[:plan_d1]) if @search[:plan_d1].present?
      rel = rel.where(:plan_end_date.lte => @search[:plan_d2]) if @search[:plan_d2].present?
      rel = rel.where(:end_date.gte => @search[:real_d1]) if @search[:real_d1].present?
      rel = rel.where(:end_date.lte => @search[:real_d2]) if @search[:real_d2].present?
    end
    @applications = rel.desc(:_id).paginate(page: params[:page_new], per_page: 10)
  end

  def new_customer
    @title = 'განცხადების თვისებები'
    @application = Network::NewCustomerApplication.find(params[:id])
  end

  def add_new_customer
    @title = 'ახალი განცხადება'
    if request.post?
      @application = Network::NewCustomerApplication.new(new_customer_params)
      @application.user = current_user
      # @application.status = Network::NewCustomerApplication::STATUS_SENT
      if @application.save
        redirect_to network_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება დამატებულია'
      end
    else
      @application = Network::NewCustomerApplication.new
    end
  end

  def edit_new_customer
    @title = 'ახალი აბონენტის განცხადების შეცვლა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      if @application.update_attributes(new_customer_params)
        redirect_to network_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება შეცვლილია'
      end
    end
  end

  def delete_new_customer
    application = Network::NewCustomerApplication.find(params[:id])
    application.destroy
    redirect_to network_home_url, notice: 'განცხადება წაშლილია!'
  end

  def link_bs_customer
    @title = 'აბონენტის დაკავშირება'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @application.update_attributes(params.require(:network_new_customer_application).permit(:customer_id))
      redirect_to network_new_customer_url(id: @application.id, tab: 'accounts')
    end
  end

  def remove_bs_customer
    application = Network::NewCustomerApplication.find(params[:id])
    application.customer_id = nil
    application.save
    redirect_to network_new_customer_url(id: application.id, tab: 'accounts')
  end

  def send_to_bs
    application = Network::NewCustomerApplication.find(params[:id])
    application.send_to_bs!
    redirect_to network_new_customer_url(id: application.id, tab: 'general'), notice: 'დარიცხვა გაგზავნილია ბილინგში'
  end

  def change_status
    @title = 'სტატუსის ცვლილება'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @message = Sys::SmsMessage.new(params.require(:sys_sms_message).permit(:message))
      @message.messageable = @application
      @message.mobile = @application.mobile
      if @message.save
        @message.send_sms!
        @application.status = params[:status].to_i
        if @application.save
          redirect_to network_new_customer_url(id: @application.id), notice: 'სტატუსი შეცვლილია'
        else
          @error = @application.errors.full_messages
        end
      end
    else
      @message = Sys::SmsMessage.new
    end
  end

  def send_sms
    @title = 'შეტყობინების გაგზავნა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @message = Sys::SmsMessage.new(params.require(:sys_sms_message).permit(:message))
      @message.messageable = @application
      @message.mobile = @application.mobile
      if @message.save
        @message.send_sms!
        redirect_to network_new_customer_url(id: @application.id, tab: 'sms'), notice: 'შეტყობინება გაგზავნილია'
      end
    else
      @message = Sys::SmsMessage.new
    end
  end

  def upload_file
    @title = 'ფაილის ატვირთვა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post? and params[:sys_file]
      @file = Sys::File.new(params.require(:sys_file).permit(:file))
      if @file.save
        @application.files << @file
        redirect_to network_new_customer_url(id: @application.id, tab: 'files'), notice: 'ფაილი დამატებულია'
      end
    else
      @file = Sys::File.new
    end
  end

  def delete_file
    application = Network::NewCustomerApplication.find(params[:id])
    file = application.files.where(_id: params[:file_id]).first
    file.destroy
    redirect_to network_new_customer_url(id: application.id, tab: 'files'), notice: 'ფაილი წაშლილია'
  end

  def change_plan_date
    @title = 'გეგმიური დასრულების თარიღის შეცვლა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      update_params = params.require(:network_new_customer_application).permit(:plan_end_date).merge(plan_end_date_changed_manually: true)
      if @application.update_attributes(update_params)
        @application.save
        redirect_to network_new_customer_url(id: @application.id), notice: 'გეგმიური დასრულების თარიღი შეცვლილია'
      end
    end
  end

  def change_real_date
    @title = 'დასრულების თარიღის შეცვლა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      if @application.update_attributes(params.require(:network_new_customer_application).permit(:end_date))
        redirect_to network_new_customer_url(id: @application.id), notice: 'დასრულების თარიღი შეცვლილია'
      end
    end
  end

  def sync_customers
    application = Network::NewCustomerApplication.find(params[:id])
    application.sync_customers!
    redirect_to network_new_customer_url(id: application.id, tab: 'accounts'), notice: 'სინქრონიზაცია დასრულებულია'
  end

  def paybill
    @application = @app = Network::NewCustomerApplication.find(params[:id])
    respond_to do |format|
      format.html do
        @title = 'საგადახდო დავალება'
        @data = { amount: @app.amount / 2.0 }
      end
      format.pdf do
        amount = params[:amount].to_f rescue @app.amount / 2.0
        @data = { date: Date.today,
          payer: @app.rs_name, payer_account: @app.bank_account, payer_bank: @app.bank_name, payer_bank_code: @app.bank_code,
          receiver: 'სს თელასი', receiver_account: 'GE53TB1147136030100001  ', receiver_bank: 'სს თიბისი ბანკი',
          receiver_bank_code: 'TBCBGE22',
          reason: "სს თელასის განამაწილებელ ქსელში ჩართვის ღირებულების 50%-ის დაფარვა. განცხადება №#{@app.effective_number}; TAXID: #{@app.rs_tin}.",
          amount: amount
        }
      end
    end
  end

  def print; @application = Network::NewCustomerApplication.find(params[:id]) end

  def send_factura
    application = Network::NewCustomerApplication.find(params[:id])
    raise 'ფაქტურის გაგზავნა დაუშვებელია' unless application.can_send_factura?
    factura = RS::Factura.new(date: Time.now, seller_id: RS::TELASI_PAYER_ID)
    amount = application.effective_amount
    raise 'თანხა უნდა იყოს > 0' unless amount > 0
    raise 'ფაქტურის გაგზავნა ვერ ხერხდება!' unless RS.save_factura(factura, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, buyer_tin: application.rs_tin))
    vat = application.pays_non_zero_vat? ? amount * (1 - 1.0 / 1.18) : 0
    factura_item = RS::FacturaItem.new(factura: factura, good: 'ქსელზე მიერთების პაკეტის ღირებულება', unit: 'მომსახურეობა', amount: amount, vat: vat, quantity: 1)
    RS.save_factura_item(factura_item, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID))
    if RS.send_factura(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
      factura = RS.get_factura_by_id(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
      application.factura_seria = factura.seria
      application.factura_number = factura.number
    end
    application.factura_id = factura.id
    application.save
    redirect_to network_new_customer_url(id: application.id, tab: 'factura'), notice: 'ფაქტურა გაგზავნილია :)'
  end

  def new_control_item
    @title = 'ახალი საკონტროლო ჩანაწერი'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @item = Network::RequestItem.new(params.require(:network_request_item).permit(:type, :date, :description, :stage_id))
      @item.source = @application
      if @item.save
        @application.update_last_request
        redirect_to network_new_customer_url(id: @application.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი დამატებულია'
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
        redirect_to network_new_customer_url(id: @item.source.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი შეცვლილია'
      end
    end
  end

  def delete_control_item
    item = Network::RequestItem.find(params[:id])
    app = item.source
    item.destroy
    app.update_last_request
    redirect_to network_new_customer_url(id: app.id, tab: 'watch'), notice: 'საკონტროლო ჩანაწერი წაშლილია'
  end

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ახალი აბონენტი' => network_new_customers_url }
    if @application
      if not @application.new_record?
        @nav[ "№#{@application.effective_number}" ] = network_new_customer_url(id: @application.id)
        @nav[@title] = nil if action_name != 'new_customer'
      else
        @nav['ახალი განცხადება'] = nil
      end
    end
    @nav
  end

  private

  def new_customer_params
    params.require(:network_new_customer_application).permit(:number, :rs_tin, :rs_foreigner, :rs_name, :personal_use, :mobile, :email, :address, :work_address, :address_code, :bank_code, :bank_account, :need_resolution, :voltage, :power, :vat_options, :need_factura, :show_tin_on_print, :notes)
  end
  
  def account_params; params.require(:network_new_customer_item).permit(:address, :address_code, :rs_tin, :customer_id) end
end

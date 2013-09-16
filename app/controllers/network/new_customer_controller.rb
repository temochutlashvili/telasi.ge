# -*- encoding : utf-8 -*-
require 'rs'

class Network::NewCustomerController < Admin::AdminController
  layout 'one_column'

  def new_customer
    @title = 'ქსელზე მიერთების განცხადება'
    @application = Network::NewCustomerApplication.find(params[:id])
  end

  def add_new_customer
    @title = 'ქსელზე მიერთების ახალი განცხადება'
    if request.post?
      @application = Network::NewCustomerApplication.new(new_customer_params)
      @application.user = current_user
      @application.status = Network::NewCustomerApplication::STATUS_SENT
      if @application.save
        redirect_to network_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება დამატებულია'
      end
    else
      @application = Network::NewCustomerApplication.new
    end
  end

  def edit_new_customer
    @title = 'ქსელზე მიერთების განცხადების შეცვლა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @application.update_attributes(new_customer_params)
      redirect_to network_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება შეცვლილია'
    end
  end

  def delete_new_customer
    application = Network::NewCustomerApplication.find(params[:id])
    application.destroy
    redirect_to network_home_url, notice: 'განცხადება წაშლილია!'
  end

  def add_new_customer_account
    @title = 'ახალი აბონენტის დამატება'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @account = Network::NewCustomerItem.new(account_params)
      @account.application = @application
      if @account.save
        @application.calculate_distribution!
        redirect_to network_new_customer_url(id: @application.id, tab: 'accounts'), notice: 'აბონენტი დამატებულია'
      end
    else
      @account = Network::NewCustomerItem.new
    end
  end

  def edit_new_customer_account
    @title = 'აბონენტის რედაქტირება'
    @application = Network::NewCustomerApplication.find(params[:app_id])
    @account = @application.items.where(id: params[:id]).first
    if request.post?
      if @account.update_attributes(account_params)
        @application.calculate_distribution!
        redirect_to network_new_customer_url(id: @application.id, tab: 'accounts'), notice: 'აბონენტი შეცვლილია'
      end
    end
  end

  def delete_new_customer_account
    application = Network::NewCustomerApplication.find(params[:app_id])
    account = application.items.where(id: params[:id]).first
    account.destroy
    application.calculate_distribution!
    redirect_to network_new_customer_url(id: application.id, tab: 'accounts')
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
    redirect_to network_new_customer_url(id: application.id, tab: 'general'), notice: 'აბონენტი გაგზავნილია ბილინგში'
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
        @application.save
        redirect_to network_new_customer_url(id: @application.id), notice: 'სტატუსი შეცვლილია'
      end
    else
      @message = Sys::SmsMessage.new
    end
  end

  def send_new_customer_sms
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

  def sync_accounts
    application = Network::NewCustomerApplication.find(params[:id])
    application.sync_accounts!
    application.calculate_distribution!
    redirect_to network_new_customer_url(id: application.id, tab: 'accounts'), notice: 'სინქრონიზაცია დასრულებულია'
  end

  def paybill
    app = Network::NewCustomerApplication.find(params[:id])
    @data = { date: Date.today,
      payer: app.rs_name, payer_account: app.bank_account, payer_bank: app.bank_name, payer_bank_code: app.bank_code,
      receiver: 'სს თელასი', receiver_account: 'GE53TB1147136030100001  ', receiver_bank: 'სს თიბისი ბანკი', receiver_bank_code: 'TBCBGE22',
      reason: "სს თელასის განამაწილებელ ქსელში ჩართვის ღირებულების 50%-ის დაფარვა. განცხადება №#{app.effective_number}.",
      amount: (app.amount / 2.0).to_i
    }
  end

  def print; @application = Network::NewCustomerApplication.find(params[:id]) end

  def send_factura
    application = Network::NewCustomerApplication.find(params[:id])
    factura = RS::Factura.new(date: Time.now, seller_id: RS::TELASI_PAYER_ID)
    if RS.save_factura(factura, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, buyer_tin: application.rs_tin))
      amount = application.amount
      vat = application.rs_vat_payer ? amount * (1-1/1.18) : 0
      factura_item = RS::FacturaItem.new(factura: factura, good: 'ქსელზე მიერთების პაკეტის ღირებულება', unit: 'ცალი', amount: amount, vat: vat, quantity: 1)
      RS.save_factura_item(factura_item, RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID))
      if RS.send_factura(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
        factura = RS.get_factura_by_id(RS::TELASI_SU.merge(user_id: RS::TELASI_USER_ID, id: factura.id))
        application.factura_seria = factura.seria
        application.factura_number = factura.number
      end
      application.factura_id = factura.id
      application.save
      redirect_to network_new_customer_url(id: application.id, tab: 'factura'), notice: 'ფაქტურა გაგზავნილია :)'
    else
      raise 'ფაქტურის გაგზავნა ვერ ხერხდება!'
    end
  end

  protected

  def nav
    @nav = { 'ქსელი' => network_home_url }
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
    params.require(:network_new_customer_application).permit(:number, :rs_tin, :rs_vat_payer, :mobile, :email, :address, :work_address, :address_code, :bank_code, :bank_account, :need_resolution, :voltage, :power, :need_factura, :show_tin_on_print)
  end
  
  def account_params; params.require(:network_new_customer_item).permit(:address, :address_code, :rs_tin, :customer_id) end
end

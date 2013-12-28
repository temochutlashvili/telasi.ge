# -*- encoding : utf-8 -*-
class Pay::PaymentsController < ApplicationController

	MODES = [LiveMode = 0, TestMode = 1]
	LANGUAGES = [LngENG = 'EN', LngGEO = 'KA']

  RESULTCODE_OK = 0
  RESULTCODE_DOUBLE = 1
  RESULTCODE_PROBLEM = -1
  RESULTCODE_NOT_FOUND = -2
  RESULTCODE_PARAMETER = -3

 	@mode = MODES[TestMode]

	def show_form
      @payment = Pay::Payment.new(amount: 100)
	end

	def confirm_form
    @payment = Pay::Payment.new(
        #user: current_user, 
        user: "current_user", 
        merchant: TELASI_MERCHANT, 
        #testmode: Payge::TESTMODE, 
        testmode: 1,
        ordercode: self.gen_order_code, currency: 'GEL', amount: params[:pay_payment][:amount],
        description: 'test payment', lng: 'ka', ispreauth: 0, postpage: 0)

    #if not request.post?
      @payment.prepare_for_step(STEP_SEND)
      @payment.user = 'current_user'
      @payment.successurl = 'http://my.telasi.ge/pay/payment/success'
      @payment.cancelurl = 'http://my.telasi.ge/pay/payment/cancel'
      @payment.errorurl = 'http://my.telasi.ge/pay/payment/error'
      @payment.callbackurl = 'http://my.telasi.ge/pay/payment/callback'
      if not @payment.save
        render action: 'show_form'
      end
    #end
  end

  def gen_order_code
    @payment = Pay::Payment.where("merchant" => TELASI_MERCHANT).sort([['ordercode', -1]]).first

    return 234566 + @payment.ordercode + 1 if @payment;
    return 234566 + 1 unless @payment;
  end

  def success
    update_payment()
  end

  def cancel
    update_payment()
  end

  def error
    update_payment()
  end

  def callback
    @payment = Pay::Payment.where("ordercode" => params[:ordercode]).first

    if !@payment
      @payment = Pay::Payment 
      @payment.resultcode = RESULTCODE_NOT_FOUND
    else
      if params[:status] = STATUS_COMPLETED
        @payment.resultcode = RESULTCODE_OK
        @payment.status = STATUS_COMPLETED

        check_response = prepare_for_step(STEP_CALLBACK)
        if check_response != params[:check]
          @payment.resultcode = RESULTCODE_PROBLEM 
          @payment.status = STATUS_ERROR
        end

       @payment.save
      end
    end
    @payment.check_response = prepare_for_step(STEP_RESPONSE)
  end

  def update_payment
    @payment = Pay::Payment.where("ordercode" => params[:ordercode]).first
    
    if @payment

      @payment.status = params[:status]
      @payment.transactioncode = params[:transactioncode]
      @payment.date = DateTime.strptime(params[:date],'%Y%m%d%H%M%S')
      @payment.paymethod = params[:paymethod]
      @payment.check_returned = params[:check]

      @payment.save

      case @payment.status 

       when STATUS_COMPLETED
         check_string = prepare_for_step(STEP_RETURNED)
         if check_string != @payment.check_returned
           redirect_to error_url
         end

       when STATUS_CANCELED
         redirect_to cancelled_url

       when STATUS_ERROR
         redirect_to error_url

      end
    end
  end

end
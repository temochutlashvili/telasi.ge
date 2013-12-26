# -*- encoding : utf-8 -*-
class Pay::PaymentsController < ApplicationController

	MODES = [LiveMode = 0, TestMode = 1]
	LANGUAGES = [LngENG = 'EN', LngGEO = 'KA']

  RESULTCODE_OK = 0
  RESULTCODE_DOUBLE = 1
  RESULTCODE_PROBLEM = -1
  RESULTCODE_NOT_FOUND = -2
  RESULTCODE_PARAMETER = -3

  STEP_SEND = 1
  STEP_RETURNED = 2
  STEP_CALLBACK = 3
  STEP_RESPONSE = 4

	@mode = MODES[TestMode]

	def show_form
      @payment = Pay::Payment.new(amount: 100)
	end

	def confirm_form
    @payment = Pay::Payment.new(
        user: current_user, merchant: Payge::MERCHANT, testmode: Payge::TESTMODE, 
        ordercode: self.gen_order_code, currency: 'GEL', amount: params[:pay_payment][:amount],
        description: 'test payment', lng: 'EN')

    #if not request.post?
      @payment.prepare_for_step(STEP_SEND)
      @payment.user = current_user
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

    return @payment.ordercode + 1 if @payment;
    return 1 unless @payment;
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
    @result = Result.new
    @payment = Pay::Payment.where("ordercode" => params[:ordercode]).first

    if !@payment
      @result.resultcode = RESULTCODE_NOT_FOUND
    else
      if params[:status] = STATUS_COMPLETED
        @result.resultcode = RESULTCODE_OK
        @payment.status = STATUS_COMPLETED

        check_response = gen_sha_string_send(STEP_CALLBACK, @payment, nil)
        if check_response != params[:check]
          @result.resultcode = RESULTCODE_PROBLEM 
          @payment.status = STATUS_ERROR
        end

        @payment.save
      end
    end
    @result.check = gen_sha_string_send(STEP_RESPONSE, @payment, @result)
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
         check_string = gen_sha_string_send(STEP_RETURNED, @payment, nil)
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

  def gen_sha_string(step, paypar, resultpar)
    case step
     when STEP_SEND# გადახდების გვერდზე გადასვლა
        return Digest::SHA256.hexdigest(Payge::PASSWORD + 
                                        paypar.merchant + 
                                        paypar.ordercode.to_s + 
                                        paypar.amount_tech.to_s + 
                                        paypar.currency + 
                                        (paypar.description || "").to_s + 
                                        (paypar.clientname || "").to_s + 
                                        (paypar.customdata || "").to_s + 
                                        (paypar.lng || "").to_s + 
                                        (paypar.testmode || "").to_s + 
                                        (paypar.ispreauth || "").to_s + 
                                        (paypar.itemN_name || "").to_s + 
                                        (paypar.itemN_price || "").to_s )
    when STEP_RETURNED # მერჩანტის გვერდზე დაბრუნება
        return Digest::SHA256.hexdigest((paypar.status || "").to_s + 
                                        (paypar.transactioncode || "").to_s + 
                                        paypar.date.strftime("%Y%m%d%H%M%S") + 
                                        paypar.amount_tech.to_s +
                                        paypar.currency +
                                        paypar.ordercode.to_s + 
                                        (paypar.paymethod || "").to_s + 
                                        (paypar.customdata || "").to_s + 
                                        (paypar.testmode || "").to_s +
                                        Payge::PASSWORD)
    when STEP_CALLBACK # PAY სისტემიდან შეტყობინების გამოგზავნა
        return Digest::SHA256.hexdigest((paypar.status || "").to_s + 
                                        (paypar.transactioncode || "").to_s + 
                                        paypar.amount_tech.to_s +
                                        paypar.currency +
                                        paypar.ordercode.to_s + 
                                        (paypar.paymethod || "").to_s + 
                                        (paypar.customdata || "").to_s + 
                                        (paypar.testmode || "").to_s +
                                        Payge::PASSWORD)
    when STEP_RESPONSE # PAY სისტემის შეტყობინებაზე პასუხი
        return Digest::SHA256.hexdigest(resultpar.resultcode +
                                        (resultpar.resultdesc || "").to_s +
                                        (paypar.transactioncode || "").to_s + 
                                        Payge::PASSWORD)
   end
  end

end

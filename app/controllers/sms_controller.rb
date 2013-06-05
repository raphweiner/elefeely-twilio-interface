class SmsController < ApplicationController
  before_filter :validate_request, only: :verify

  def create
    @sms_response = ResponseViaTwilioSMS.new(params)
    @sms_response.forward
    send_sms_feeler_if_verifying

    render xml: @sms_response.reply_xml
  end

  def verify
    Resque.enqueue(SendSmsJob, :verification, params[:number])
  end

private

  def send_sms_feeler_if_verifying
    if @sms_response.verifying?
      Resque.enqueue(SendSmsJob, :feeler, @sms_response.phone_number)
    end
  end
end

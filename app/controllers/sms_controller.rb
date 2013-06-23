class SmsController < ApplicationController
  before_filter :validate_request, only: :verify

  def create
    sms_response = ResponseViaTwilioSMS.new(params)
    sms_response.send

    render xml: sms_response.reply_xml
  end

  def verify
    Resque.enqueue(SendSmsJob, :verification, params[:number])
  end
end

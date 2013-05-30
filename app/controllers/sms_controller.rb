class SmsController < ApplicationController
  before_filter :validate_request, only: :validate

  def create
    sms_response = ResponseViaTwilioSMS.new(params)
    sms_response.forward

    render xml: sms_response.reply_xml
  end

  def validate
    Resque.enqueue(SendSmsJob, :validation, params[:number])
  end
end

class Elefeely
  def self.send_feeling(params)
  end

  def self.validate_number(params)
  end
end

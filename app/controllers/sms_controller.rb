class SmsController < ApplicationController
  before_filter :validate_request, only: :validate

  def create
    sms_message = ResponseViaTwilioSMS.new(params)

    sms_message.perform

    render xml: sms_message.response_xml
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

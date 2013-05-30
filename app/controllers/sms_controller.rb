class SmsController < ApplicationController
  before_filter :validate_request, only: :validate

  def create
    sms_message = TwilioFeelingSMS.new(params)

    if sms_message.valid?
      Elefeely.send_feeling(source: 'twilio',
                            event_id: sms_message.sms_sid,
                            feeling: sms_message.body,
                            uid: sms_message.phone_number)
    end

    render xml: sms_message.response_xml
  end

  def validate
    Resque.enqueue(SendSmsJob, :validation, params[:number])
  end
end

class Elefeely
  def self.send_feeling(params)
  end
end

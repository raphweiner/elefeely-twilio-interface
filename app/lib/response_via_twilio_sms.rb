class ResponseViaTwilioSMS
  attr_reader :sms_sid, :body, :phone_number

  def initialize(params)
    @sms_sid = params['SmsSid']
    @body = params['Body'].downcase
    @phone_number = params['From']
  end

  def forward
    if validation_response?
      Elefeely.validate_number(phone_number)
    elsif valid_feeling?
      Elefeely.send_feeling(source: 'twilio',
                            event_id: sms_sid,
                            feeling: body,
                            uid: phone_number)
    end
  end

  def reply_xml
    message = reply || invalid_input_reply

    {:Sms => message}.to_xml(:root => 'Response')
  end

private

  def validation_response?
    @body == 'valid'
  end

  def valid_feeling?
    sms_sid && (1..5).include?(body.to_i) && phone_number
  end

  def reply
    {
      '5' => 'Great to hear!',
      '4' => 'Nice!',
      '3' => 'Gotcha. Hope something exciting happens.',
      '2' => 'Ok, rest up!',
      '1' => 'Sorry to hear it :(',
      'valid' => 'Thanks! Your number has been validated'
    }[body]
  end

  def invalid_input_reply
    "Please enter a number 1-5"
  end
end

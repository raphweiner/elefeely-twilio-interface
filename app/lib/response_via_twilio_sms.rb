class ResponseViaTwilioSMS
  attr_reader :sms_sid,
              :body,
              :phone_number

  def initialize(params)
    @sms_sid = params['SmsSid']
    @body = params['Body'].downcase
    @phone_number = last_ten_digits(params['From'])
  end

  def forward
    if verification_response?
      Elefeely.verify_number(phone_number)
    elsif unsubscribe_response?
      Elefeely.unsubscribe_number(phone_number)
    elsif valid_feeling?
      Elefeely.send_feeling(feeling: { score: body, source_event_id: sms_sid },
                            uid: phone_number)
    end
  end

  def reply_xml
    message = reply || invalid_input_reply

    {:Sms => message}.to_xml(:root => 'Response')
  end

private

  def last_ten_digits(number)
    number.try(:[], (-10..-1))
  end

  def verification_response?
    @body == 'verify'
  end

  def unsubscribe_response?
    @body == '0'
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
      '0' => 'Your number has been unsubscribed',
      'verify' => 'Thanks! Your number has been verified'
    }[body]
  end

  def invalid_input_reply
    "Please enter a number 1-5"
  end
end

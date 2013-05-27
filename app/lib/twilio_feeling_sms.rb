class TwilioFeelingSMS
  attr_reader :sms_sid, :body, :phone_number

  def initialize(params)
    @sms_sid = params['SmsSid']
    @body = params['Body'].to_i
    @phone_number = params['From']
  end

  def valid?
    sms_sid && (1..5).include?(body) && phone_number
  end

  def response_xml
    message = reply || invalid_input_reply

    {:Sms => message}.to_xml(:root => 'Response')
  end

private

  def reply
    {
      5 => 'Great to hear!',
      4 => 'Nice!',
      3 => 'Gotcha. Hope something exciting happens.',
      2 => 'Ok, rest up!',
      1 => 'Sorry to hear it :('
    }[body]
  end

  def invalid_input_reply
    "Please enter a number 1-5"
  end
end

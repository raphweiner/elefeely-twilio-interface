class Feely
  attr_reader :sms_sid, :body, :phone_number

  def initialize(params)
    @sms_sid = params['SmsSid']
    @body = params['Body']
    @phone_number = params['From']
  end

  def message
    {'5' => 'Great to hear!',
     '4' => 'Nice!',
     '3' => 'Gotcha. Hope something exciting happens.',
     '2' => 'Ok, rest up!',
     '1' => 'Sorry to hear it :('
    }[body]
  end

  def send
    if sms_sid && body && phone_number
      Elefeely.create(sms_sid: sms_sid,
                      body: body,
                      phone_number: phone_number)
    end
  end

  def self.new_and_send(params)
    feely = new(params)
    feely.send
    feely
  end
end

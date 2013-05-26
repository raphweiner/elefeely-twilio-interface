class Feely
  attr_reader :sms_sid, :body, :phone_number

  def initialize(params)
    @sms_sid = params['SmsSid']
    @body = params['Body'].to_i
    @phone_number = params['From']
  end

  def message
    response = Hash.new("Please enter a number 1-5")
    response.merge!(5 => 'Great to hear!',
                    4 => 'Nice!',
                    3 => 'Gotcha. Hope something exciting happens.',
                    2 => 'Ok, rest up!',
                    1 => 'Sorry to hear it :(')

    response[body]
  end

  def send
    if valid?
      Elefeely.create(source: 'twilio',
                      event_id: sms_sid,
                      score: body,
                      uid: phone_number)
    end
  end

  def self.new_and_send(params)
    feely = new(params)
    feely.send
    feely
  end

private

  def valid?
    sms_sid && (1..5).include?(body) && phone_number
  end
end

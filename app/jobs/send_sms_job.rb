class SendSmsJob
  @queue = :send_sms_queue

  def self.perform(sms_type, phone_number)
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'],
                                      ENV['TWILIO_AUTH_TOKEN'])

    self.send(sms_type, client, phone_number)
  end

private

  def self.feeler(client, phone_number)
    client.account.sms.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   phone_number,
      body: 'Elefeely: How are you?
             1-Sad,
             2-Tired,
             3-Okay,
             4-Good,
             5-Awesome'
    )
  end

  def self.verification(client, phone_number)
    client.account.sms.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to:   phone_number,
      body: 'Elefeely: Please respond "verify" to complete signup'
    )
  end
end

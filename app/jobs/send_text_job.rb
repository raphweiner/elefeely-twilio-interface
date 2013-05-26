class SendTextJob
  @queue = :send_text_queue

  def self.perform(phone_number)
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'],
                                      ENV['TWILIO_AUTH_TOKEN'])

    send_sms(client, phone_number)
  end

private

  def self.send_sms(client, phone_number)
    client.account.sms.messages.create(
      :from => ENV['TWILIO_PHONE_NUMBER'],
      :to => phone_number,
      :body => 'How are you feeling? 1-Sad, 2-Tired, 3-Okay, 4-Good, 5-Awesome'
    )
  end
end

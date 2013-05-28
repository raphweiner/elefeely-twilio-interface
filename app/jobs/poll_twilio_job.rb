class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    req = Faraday.get("http://elefeely-api.herokuapp.com/phones/verified")
    body = JSON.parse(req.body)
    phone_numbers = body['phone_numbers']

    enqueue_smss(phone_numbers)
  end

private

  def self.enqueue_smss(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendSmsJob, number) }
  end
end

class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    phone_numbers = ElefeelyAPIRequest.phone_numbers

    enqueue_smss(phone_numbers)
  end

private

  def self.enqueue_smss(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendSmsJob, number) }
  end
end

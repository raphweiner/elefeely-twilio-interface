class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    enqueue_smss(Elefeely.phone_numbers)
  end

private

  def self.enqueue_smss(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendSmsJob, number) }
  end
end

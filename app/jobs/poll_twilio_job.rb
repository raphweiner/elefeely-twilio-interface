class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    response = Elefeely.phone_numbers

    enqueue_smss(response['phone_numbers'])
  end

private

  def self.enqueue_smss(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendSmsJob, :feeler, number) }
  end
end

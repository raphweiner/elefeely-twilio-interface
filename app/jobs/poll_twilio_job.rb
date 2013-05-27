class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    phone_numbers = Elefeely.retrieve_phone_numbers

    enqueue_smss(phone_numbers)
  end

private

  def self.enqueue_smss(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendSmsJob, number) }
  end
end

class Elefeely
  def self.retrieve_phone_numbers
    ['4157455607']
  end

  def self.send_feeling(params)
  end
end

class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    phone_numbers = Elefeely.retrieve_phone_numbers

    enqueue_texts(phone_numbers)
  end

private

  def self.enqueue_texts(phone_numbers)
    phone_numbers.each { |number| Resque.enqueue(SendTextJob, number) }
  end
end

class Elefeely; end

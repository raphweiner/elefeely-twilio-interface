class PollTwilioJob
  @queue = :twilio_queue

  def self.perform
    puts "hi there!"
  end
end

class SendTextJob
  @queue = :send_text_queue

  def self.perform(phone_number)
    Elefeely.send_text(phone_number)
  end
end

require 'spec_helper'

describe PollTwilioJob do
  describe '.perform' do
    it 'retrieves all phone numbers from the ElefeelyAPIRequest' do
      PollTwilioJob.stub(:enqueue_smss)
      Elefeely.should_receive(:phone_numbers)

      PollTwilioJob.perform
    end

    it 'enqueues job to send text' do
      Elefeely.stub(:phone_numbers).and_return(['1234567890'])
      Resque.should_receive(:enqueue).with(SendSmsJob, '1234567890')

      PollTwilioJob.perform
    end
  end
end

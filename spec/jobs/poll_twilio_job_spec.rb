require 'spec_helper'

describe PollTwilioJob do
  describe '.perform' do
    it 'retrieves all phone numbers from the ElefeelyAPI' do
      PollTwilioJob.stub(:enqueue_smss)
      ElefeelyAPI.should_receive(:phone_numbers)

      PollTwilioJob.perform
    end

    it 'enqueues job to send text' do
      ElefeelyAPI.stub(:phone_numbers).and_return(['1234567890'])
      Resque.should_receive(:enqueue).with(SendSmsJob, '1234567890')

      PollTwilioJob.perform
    end
  end
end

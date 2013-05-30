require 'spec_helper'

describe PollTwilioJob do
  describe '.perform' do
    it 'retrieves all phone numbers from the ElefeelyAPIRequest' do
      PollTwilioJob.stub(:enqueue_smss)
      Elefeely.should_receive(:phone_numbers).and_return('abc')

      PollTwilioJob.perform
    end

    it 'enqueues job to send text' do
      Elefeely.stub(:phone_numbers).and_return('phone_numbers' => ['1234567890'])
      Resque.should_receive(:enqueue).with(SendSmsJob, :feeler, '1234567890')

      PollTwilioJob.perform
    end
  end
end

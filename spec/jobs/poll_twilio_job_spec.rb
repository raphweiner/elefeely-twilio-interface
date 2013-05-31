require 'spec_helper'

describe PollTwilioJob do
  describe '.perform' do
    it 'enqueues job to send text it gets from the gem' do
      Elefeely.stub(:phone_numbers).and_return('phone_numbers' => ['1234567890'])
      Resque.should_receive(:enqueue).with(SendSmsJob, :feeler, '1234567890')

      PollTwilioJob.perform
    end
  end
end

require 'spec_helper'

describe PollTwilioJob do
  describe '.perform' do
    it 'retrieves all phone numbers' do
      Elefeely.should_receive(:retrieve_phone_numbers).and_return(['1'])
      PollTwilioJob.perform
    end

    it 'enqueues job to send text' do
      Elefeely.stub(:retrieve_phone_numbers).and_return(['1234567890'])
      Resque.should_receive(:enqueue).with(SendTextJob, '1234567890')
      PollTwilioJob.perform
    end
  end
end

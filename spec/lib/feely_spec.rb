require 'spec_helper'

describe Feely do
  describe '.new_and_send' do
    context 'happy path' do
      before(:each) do
        @params ||= YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
      end

      it 'returns an instance of Feely' do
        expect(Feely.new_and_send(@params)).to be_an_instance_of Feely
      end

      it 'sends a new request to Elefeely' do
        Elefeely.should_receive(:create).with(sms_sid: "SM3f1860d2509ab13995cfa6e7b922d9a3",
                                              body: "5",
                                              phone_number: "+14157455607")

        Feely.new_and_send(@params)
      end
    end

    context 'sad path' do
      let(:params) { {'hi' => 'oh hai'} }

      it 'returns an instance of Feely' do
        expect(Feely.new_and_send(params)).to be_an_instance_of Feely
      end

      it 'does not send a new request to Elefeely' do
        Elefeely.should_not_receive(:create)

        Feely.new_and_send(params)
      end
    end
  end
end

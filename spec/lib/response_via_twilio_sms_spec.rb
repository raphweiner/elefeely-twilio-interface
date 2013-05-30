require 'spec_helper'

describe ResponseViaTwilioSMS do
  before(:all) do
    @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
  end

  subject do
    ResponseViaTwilioSMS.new(@params)
  end

  describe '.perform' do
    context 'when it is a validation response' do
      it 'calls .validate_number on elefeely gem' do
        subject.stub(validation_response?: true)
        Elefeely.should_receive(:validate_number).with(@params['From'])

        subject.perform
      end
    end

    context 'when it is a valid feeling' do
      it 'calls .send_feeling on elefeel gem' do
        subject.stub(valid?: true)
        Elefeely.should_receive(:send_feeling)

        subject.perform
      end
    end

    context 'when it neither a valid feeling nor a validation response' do
      it 'does not call .validate_number nor .send_feeling' do
        subject.stub(valid?: false)
        subject.stub(validation_response?: false)
        Elefeely.should_not_receive(:validate_number)
        Elefeely.should_not_receive(:send_feeling)

        subject.perform
      end
    end
  end

  describe '.valid?' do
    it 'is valid with correct params' do
      expect(subject).to be_valid
    end

    it 'requires an sms_sid' do
      expect(ResponseViaTwilioSMS.new(@params.merge('SmsSid' => nil))).to_not be_valid
    end

    it 'requires a from' do
      expect(ResponseViaTwilioSMS.new(@params.merge('From' => nil))).to_not be_valid
    end

    it 'requires a valid body between 1-5' do
      expect(ResponseViaTwilioSMS.new(@params.merge('Body' => 'hello'))).to_not be_valid
      expect(ResponseViaTwilioSMS.new(@params.merge('Body' => '6'))).to_not be_valid
    end
  end

  describe '.response_xml' do
    def xml_response(message)
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Sms>#{message}</Sms>\n</Response>\n"
    end

    it 'responds with the correct message when body is 5' do
      sms_message = ResponseViaTwilioSMS.new(@params)
      expect(sms_message.response_xml).to eq xml_response('Great to hear!')
    end

    it 'responds with the correct message when body is 4' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => '4'))
      expect(sms_message.response_xml).to eq xml_response('Nice!')
    end

    it 'responds with the correct message when body is 3' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => '3'))
      expect(sms_message.response_xml).to eq xml_response('Gotcha. Hope something exciting happens.')
    end

    it 'responds with the correct message when body is 2' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => '2'))
      expect(sms_message.response_xml).to eq xml_response('Ok, rest up!')
    end

    it 'responds with the correct message when body is 1' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => '1'))
      expect(sms_message.response_xml).to eq xml_response('Sorry to hear it :(')
    end

    it 'responds with the correct message when body is valid' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => 'VALID'))
      expect(sms_message.response_xml).to eq xml_response('Thanks! Your number has been validated')
    end

    it 'responds with the correct message when body is invalid' do
      sms_message = ResponseViaTwilioSMS.new(@params.merge('Body' => 'invalid'))
      expect(sms_message.response_xml).to eq xml_response('Please enter a number 1-5')
    end
  end
end

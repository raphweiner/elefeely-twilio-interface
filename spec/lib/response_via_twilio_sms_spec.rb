require 'spec_helper'

describe ResponseViaTwilioSMS do
  before(:all) do
    @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
  end

  subject do
    ResponseViaTwilioSMS.new(@params)
  end

  describe '.forward' do
    context 'when it is a verification response' do
      it 'calls .verify_number on elefeely gem' do
        subject.stub(verifying?: true)
        Elefeely.should_receive(:verify_number).with(@params['From'][-10..-1])

        subject.forward
      end
    end

    context 'when it is an unsubscription response' do
      it 'calls .unsubscribe_number on elefeely gem' do
        subject.stub(unsubscription?: true)
        Elefeely.should_receive(:unsubscribe_number).with(@params['From'][-10..-1])

        subject.forward
      end
    end

    context 'when it is a valid feeling' do
      it 'calls .send_feeling on elefeel gem' do
        subject.stub(valid_feeling?: true)
        Elefeely.should_receive(:send_feeling)

        subject.forward
      end
    end

    context 'when it neither a valid feeling nor other valid response' do
      it 'does not call .verify_number, .unsubscribe_number nor .send_feeling' do
        subject.stub(valid_feeling?: false)
        Elefeely.should_not_receive(:verify_number)
        Elefeely.should_not_receive(:send_feeling)

        subject.forward
      end
    end
  end

  describe '.valid_feeling?' do
    it 'is valid with correct params' do
      expect(subject).to be_valid_feeling
    end

    it 'requires an sms_sid' do
      expect(ResponseViaTwilioSMS.new(@params.merge('SmsSid' => nil))).to_not be_valid_feeling
    end

    it 'requires a from' do
      expect(ResponseViaTwilioSMS.new(@params.merge('From' => nil))).to_not be_valid_feeling
    end

    it 'requires a valid body between 1-5' do
      expect(ResponseViaTwilioSMS.new(@params.merge('Body' => 'hello'))).to_not be_valid_feeling
      expect(ResponseViaTwilioSMS.new(@params.merge('Body' => '6'))).to_not be_valid_feeling
    end
  end

  describe '.reply_xml' do
    def xml_response(message)
      ({:Sms => message}.to_xml(:root => 'Response'))
    end

    it 'responds with the correct message when body is 5' do
      sms_response = ResponseViaTwilioSMS.new(@params)
      expect(sms_response.reply_xml).to eq xml_response('Great to hear!')
    end

    it 'responds with the correct message when body is 4' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => '4'))
      expect(sms_response.reply_xml).to eq xml_response('Nice!')
    end

    it 'responds with the correct message when body is 3' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => '3'))
      expect(sms_response.reply_xml).to eq xml_response('Gotcha. Hope something exciting happens.')
    end

    it 'responds with the correct message when body is 2' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => '2'))
      expect(sms_response.reply_xml).to eq xml_response('Ok, rest up!')
    end

    it 'responds with the correct message when body is 1' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => '1'))
      expect(sms_response.reply_xml).to eq xml_response('Sorry to hear it :(')
    end

    it 'responds with the correct message when body is valid' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => 'VERIFY'))
      expect(sms_response.reply_xml).to eq xml_response('Thanks! Your number has been verified')
    end

    it 'responds with the correct message when body is valid' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => '0'))
      expect(sms_response.reply_xml).to eq xml_response("You've been unsubscribed. If this was a mistake, reply 'verify' to re-subscribe")
    end

    it 'responds with the correct message when body is invalid' do
      sms_response = ResponseViaTwilioSMS.new(@params.merge('Body' => 'invalid'))
      expect(sms_response.reply_xml).to eq xml_response('Please enter a number 1-5')
    end
  end
end

require 'spec_helper'

describe Feely do
  before(:all) do
    @params = YAML.load_file(Rails.root.join('spec/support', 'twilio_callback.yml'))
  end

  describe '.new_and_send' do
    context 'happy path' do

      it 'returns an instance of Feely' do
        expect(Feely.new_and_send(@params)).to be_an_instance_of Feely
      end

      it 'sends a new request to Elefeely' do
        feely = mock('feely')
        Feely.stub(:new).and_return(feely)
        feely.should_receive(:send)

        Feely.new_and_send(@params)
      end
    end

    context 'sad path' do
      let(:params) { {'hi' => 'oh hai'} }

      it 'returns an instance of Feely' do
        expect(Feely.new_and_send(params)).to be_an_instance_of Feely
      end
    end
  end

  describe '#message' do
    it 'returns the appropriate response when body is 5' do
      params = { 'Body' => '5' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Great to hear!'
    end

    it 'returns the appropriate response when body is 4' do
      params = { 'Body' => '4' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Nice!'
    end

    it 'returns the appropriate response when body is 3' do
      params = { 'Body' => '3' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Gotcha. Hope something exciting happens.'
    end

    it 'returns the appropriate response when body is 2' do
      params = { 'Body' => '2' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Ok, rest up!'
    end

    it 'returns the appropriate response when body is 1' do
      params = { 'Body' => '1' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Sorry to hear it :('
    end

    it 'returns the appropriate response when body is invalid' do
      params = { 'Body' => 'i am a 3' }
      feely = Feely.new(params)
      expect(feely.message).to eq 'Please enter a number 1-5'
    end
  end

  describe '.send' do
    context 'as a valid instance' do
      it 'sends post request to elefeely' do
        Elefeely.should_receive(:create).with(source: 'twilio',
                                              event_id: "SM3f1860d2509ab13995cfa6e7b922d9a3",
                                              score: 5,
                                              uid: "+14157455607")

        feely = Feely.new(@params)
        feely.send
      end
    end

    context 'as an invalid instance' do
      it 'does not create a new post request' do
        Elefeely.should_not_receive(:create)

        feely = Feely.new(@params.merge('Body' => 'one' ))
        feely.send
      end
    end
  end
end

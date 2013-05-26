require 'spec_helper'

describe SendTextJob do
  describe '.perform' do
    it 'sends one text' do
      Elefeely.should_receive(:send_text).with('1234567890')
      SendTextJob.perform('1234567890')
    end
  end
end

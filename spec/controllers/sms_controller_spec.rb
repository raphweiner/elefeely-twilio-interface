require 'spec_helper'

describe SmsController do
  describe 'POST #create' do
    it 'raises boom' do
      post :create
      expect(response).to render_template('hi')
    end
  end
end


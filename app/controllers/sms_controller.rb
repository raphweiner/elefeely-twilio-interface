class SmsController < ApplicationController
  def create
    feely = Feely.new_and_send(params)
    render :xml => {:Sms => feely.message}.to_xml(:root => 'Response')
  end
end

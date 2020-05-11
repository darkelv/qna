require 'rails_helper'

RSpec.describe DailyJob, type: :job do
  let(:service) { double('DailyDigestService') }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'call DailyDigestService' do
    expect(service).to receive(:send_digest)
    DailyJob.perform_now
  end
end

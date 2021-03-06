require 'journey'

describe Journey do

  subject(:journey) { described_class.new }

  it 'class has been created' do
    expect(subject).to be_a(Journey)
  end

  describe 'start journey' do
    let(:station) {double :station}
    it "stores the station" do
      journey.start_journey(station)
      expect(journey.entry_station).to eq(station)
    end
    it {is_expected.to respond_to(:start_journey).with(1).argument}
  end

  describe 'end journey' do
    let(:station) {double :station}
    it "stores the station" do
      journey.end_journey(station)
      expect(journey.exit_station).to eq(station)
    end
    it {is_expected.to respond_to(:end_journey).with(1).argument}
  end

  describe 'calculate fare' do
    it {is_expected.to respond_to(:calculate_fare).with(0).argument}
    it 'returns min fare' do
      expect(journey.calculate_fare).to eq(Oystercard::MIN_FARE)
    end
  end

  describe 'journey completed' do
    let(:station) {double :station}
    it {is_expected.to respond_to(:complete?).with(0).argument}
    it 'false when class is brand new' do
      expect(journey.complete?).to be_falsey
    end
    it 'false when class journey started but not ended' do
      journey.start_journey(station)
      expect(journey.complete?).to be_falsey
    end
    it 'true when journey ended' do
      journey.start_journey(station)
      journey.end_journey(station)
      expect(journey.complete?).to be_truthy
    end
  end
end

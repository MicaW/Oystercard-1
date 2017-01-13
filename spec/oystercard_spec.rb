require 'oystercard'

describe Oystercard do

  init_amount = 50
  let(:station) {"Bank"}
  subject(:oystercard) { described_class.new }

  maximum_balance = Oystercard::MAX_BALANCE
  min_fare = Oystercard::MIN_FARE

  describe 'class exists' do
    it 'checks whether creates an instance of a class' do
      expect(oystercard).to be_a(Oystercard)
    end
    it 'has a balance of nil' do
      expect(oystercard.balance).to eq(0)
    end
  end

  describe 'accessing balance' do
    it {is_expected.to respond_to(:balance).with(0).argument}
    it 'creates an instance with balance' do
      expect(oystercard.balance).to eq(init_amount)
    end
  end

  describe 'top_up' do
    number = 10
    it "top_ups by £#{number}" do
      expect{ oystercard.top_up(number) }.to change{ oystercard.balance }.by number
    end
    it "stops user from having a balance beyond £#{maximum_balance}" do
      error_message = "Your card's balance cannot exceed £#{maximum_balance}."
      expect {oystercard.top_up(maximum_balance + 1)}.to raise_error (error_message)
    end
  end

  describe 'touch_in' do
    let(:station) {double :station}
    it 'sets value for variable in_journey to true' do
      oystercard.touch_in(station)
      expect(oystercard).to be_in_journey
    end
    it 'charges a penalty if user is trying to check in while already check in' do
      oystercard.touch_in(station)
      expect {oystercard.touch_in(station)}.to change{ oystercard.balance }.by -oystercard.penalty
    end
    it 'raised an error if card has insufficient funds' do
      error_message = "Insufficient funds for the journey."
      expect{oystercard.touch_in(station)}.to raise_error(error_message)
    end
    it { is_expected.to respond_to(:touch_in).with(1).argument }
  end

  describe 'touch_out' do
    let(:station) {double :station}
    it 'sets value for variable in_journey to false' do
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard).to_be complete?
    end
    it "deducts the minimum fare of £#{min_fare} when touching out" do
      oystercard.touch_in(station)
      expect{ oystercard.touch_out(station) }.to change{ oystercard.balance }.by -min_fare
    end
    it 'already checked out' do
      expect {oystercard.touch_out(station)}.to change{ oystercard.balance }.by -oystercard.penalty
    end
    it 'sets entry station to nil' do
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard.entry_station).to eq nil
    end
  end

  describe 'history' do
    let(:station) {double :station}
    it 'history is empty by default' do
      expect(oystercard.history).to be_empty
    end
    it 'shows the one journey history of the card' do
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard.history).to eq ({"j1"=>[station, station]})
    end
    it 'shows the history of stations the card has been to, when more than 1' do
      n = 7
      hash = Hash.new
      n.times do
        oystercard.touch_in(station)
        oystercard.touch_out(station)
        hash.store("j#{hash.length + 1}",[station,station])

      end
      expect(oystercard.history).to eq (hash)
    end
  end
end

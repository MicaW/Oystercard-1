require 'journey_log'

describe JourneyLog do

subject(:journey_log) { described_class.new "journey_class"}

it 'when initialized it stores a parameter journey class' do
  expect(journey_log.journey_class).to eq(Journey)
end

end

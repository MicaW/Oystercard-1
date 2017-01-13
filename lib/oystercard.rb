require_relative 'journey.rb'
require_relative 'journey_log.rb'

class Oystercard

  MAX_BALANCE = 90
  MIN_FARE = 1
  PENALTY = 6

  def initialize(amount = 0, max_balance = MAX_BALANCE, min_fare = MIN_FARE, penalty = PENALTY)
    @balance = amount
    @max_balance = max_balance
    @min_fare = min_fare
    @penalty = penalty
    @history = JourneyLog.new
  end

  attr_accessor :max_balance, :min_fare, :penalty
  attr_reader :balance, :entry_station, :history

  def top_up(amount)
    exceed_max_balance?(amount)
    @balance += amount
  end

  def touch_in(station)
    already_in?
    sufficient_funds?
    @history.start_journey(station)
  end

  def touch_out(station)
    charge_on_exit
    log_journey(station)
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def log_journey(station)
    @history.finish_journey(station)
  end

  def exceed_max_balance?(amount)
    error_message = "Your card's balance cannot exceed £#{@max_balance}."
    raise error_message if @balance + amount > @max_balance
  end

  def already_in?
    if !Journey.complete?
      p "You are have been charged with penalty fair of #{@penalty} as you did not touch out on your last journey."
      deduct(@penalty)
      log_journey("n/a")
    end
  end

  def charge_on_exit
    if !Journey.complete?
      p "You are have been charged with penalty fair of #{@penalty} as you did not touch in."
      deduct(@penalty)
      touch_in("n/a")
    else
      deduct(@min_fare)
    end
  end

  def sufficient_funds?
    error_message = "Insufficient funds for the journey."
    raise error_message if @balance < @min_fare
  end

end

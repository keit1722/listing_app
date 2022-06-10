class OpeningHourDecorator < ApplicationDecorator
  delegate_all

  def start_time
    "#{object.start_time_hour}:#{object.start_time_minute}"
  end

  def end_time
    "#{object.end_time_hour}:#{object.end_time_minute}"
  end
end

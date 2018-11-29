class TimeCalculator
  TIME_FORMATS = ["year", "month", "day", "hour", "min", "sec"]

  def initialize(time)
    @time = time
  end

  def form_time_string
    unknown_formats = []
    @time.each do |t|
      unknown_formats.push(t) unless TIME_FORMATS.include?(t)
    end

    return ("Unkown time format: #{unknown_formats}\n") if unknown_formats.length > 0    

    final_string = ""
    @time.each do |t|
      final_string += "#{ Time.now.send(t) }-"
    end

    final_string.chomp!("-")
    final_string += "\n"
    final_string
  end
end

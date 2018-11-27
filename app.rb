class App
  TIME_PATH = "/time"
  FORMAT_QUERY_BEGIN = "format="
  TIME_FORMATS = ["year", "month", "day", "hour", "minute", "second"]

  def call(env)
    if env["PATH_INFO"] == TIME_PATH
      show_time(env["QUERY_STRING"])
    else
      [status_404, headers, body]
    end
  end

  private

  def show_time(query)
    return [status_400, headers, bad_query] unless query[0..6] == FORMAT_QUERY_BEGIN

    body = []
    query = query[7..-1]
    time = query.split('%2C')

    unknown_formats = []
    time.each do |t|
      unknown_formats.push(t) unless TIME_FORMATS.include?(t)
    end

    body.push("Unkown time format: #{unknown_formats}") if unknown_formats.length > 0
    return [status_400, headers, body] if body.length > 0

    final_string = ""
    time.each do |t|
      final_string += "#{Time.now.year}-" if t == "year"
      final_string += "#{Time.now.month}-" if t == "month"
      final_string += "#{Time.now.day}-" if t == "day"
      final_string += "#{Time.now.hour}-" if t == "hour"
      final_string += "#{Time.now.min}-" if t == "minute"
      final_string += "#{Time.now.sec}-" if t == "second"
    end

    final_string.chomp!("-")
    body.push("#{final_string}\n")

    [status_200, headers, body]
  end

  def status_200
    200
  end

  def status_400
    400
  end

  def status_404
    404
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    ["Some time"]
  end

  def bad_query
    ["Bad Query\n"]
  end

end

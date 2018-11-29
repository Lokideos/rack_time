class App
  TIME_PATH = "/time"
  FORMAT_QUERY_BEGIN = "format="
  TIME_FORMATS = ["year", "month", "day", "hour", "minute", "second"]

  def call(env)
    request = Rack::Request.new(env)

    result = time_response(request.query_string) if request.path == TIME_PATH
    result ||= not_found_response

    response = Rack::Response.new(result[2])
    response.set_header(result[1].keys.first, result[1].values.first)
    response.status = result[0]
    response.finish
  end

  private

  def time_response(query)
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
      final_string += "#{ Time.now.send(t) }-"
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

  def bad_path
    ["Bad path\n"]
  end

  def bad_query
    ["Bad Query\n"]
  end

  def not_found_response
    [status_404, headers, bad_path]
  end

end

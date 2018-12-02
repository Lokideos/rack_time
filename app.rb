require_relative 'application/time_calculator'

class App
  TIME_PATH = "/time"
  FORMAT_QUERY_BEGIN = "format="

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response.set_header('Content-Type', 'text/plain')

    if request.path == TIME_PATH
      response.status = time_response(request.query_string).first
      response.body = time_response(request.query_string).last
    else
      response.status = not_found_response.first
      response.body = not_found_response.last    
    end

    response.finish
  end

  private

  def time_response(query)
    return [400, bad_query] unless query[0..6] == FORMAT_QUERY_BEGIN

    body = []
    query = query[7..-1]
    time = query.split('%2C')

    calculator = TimeCalculator.new(time)
    body.push(calculator.form_time_string)

    return [400, body] if body[0][0..6] == "Unknown"

    [200, body]
  end

  def bad_path
    ["Bad Path\n"]
  end

  def bad_query
    ["Bad Query\n"]
  end

  def not_found_response
    [404, bad_path]
  end

end

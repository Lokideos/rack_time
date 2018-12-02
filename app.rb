require_relative 'application/time_calculator'

class App
  TIME_PATH = "/time"
  FORMAT_QUERY_BEGIN = "format"

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response.set_header('Content-Type', 'text/plain')

    if request.path == TIME_PATH
      response.status = time_response(request.params).first
      response.body = time_response(request.params).last
    else
      not_found_response(response)
    end

    response.finish
  end

  private
  def time_response(params)
    return [400, bad_query] unless has_format_params?(params)

    body = []
    calculator = TimeCalculator.new(params['format'])
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

  def not_found_response(response)
    response.status = 404
    response.body = bad_path
  end

  def has_format_params?(params)
    params.keys.include?(FORMAT_QUERY_BEGIN)
  end
end

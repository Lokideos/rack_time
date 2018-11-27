class App
  TIME_PATH = "/time"
  FORMAT_QUERY_BEGIN = "format="

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

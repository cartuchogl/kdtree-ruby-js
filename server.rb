# based on:
#  http://segment7.net/projects/ruby/WEBrick/servlets.html
#  http://onestepback.org/index.cgi/Tech/Ruby/WEBrick.rdoc
require 'webrick'
require "tree2d"

class Collections::TreeKD
  def to_json
    ret = "{\n"
    ret += "v:["+@value.tuple.join(",")+"]"
    ret += ",\n"+"r:"+@right.to_json unless @right.nil?
    ret += ",\n"+"l:"+@left.to_json unless @left.nil?
    ret += "\n"+"}\n"
    ret
  end
end

class Simple < WEBrick::HTTPServlet::AbstractServlet
  
  def do_GET(request, response)
    status, content_type, body = do_stuff_with(request)
    
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end
  
  def do_stuff_with(request)
    points = []
    1.upto(50) do |x|
      1.upto(50) do |y|
        points << Collections::Point2D.new( x, y)
      end
    end

    tree = Collections::Tree2D.new(points)

    target = Collections::Point2D.new(3.1, 3.1)
    v = tree.nearest(target)

    return 200, "text/javascript", "tree = "+tree.to_json
  end
  
end

include WEBrick

dir = Dir::pwd
port = 12000

puts "URL: http://#{Socket.gethostname}:#{port}"

s = HTTPServer.new(
  :Port            => port,
  :DocumentRoot    => dir
)
s.mount "/data.js", Simple

trap("INT"){ s.shutdown }
s.start


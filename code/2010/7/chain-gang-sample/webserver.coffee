sys:  require 'sys'
uri:  require 'url'
http: require 'http'
port: parseInt(process.env.PORT) or 8080

server: http.createServer (req, res) ->
  url: uri.parse req.url
  paths: url.pathname.split('/')
  paths.shift() # strip empty value

  timeout: parseFloat(paths[0])
  if timeout
    name: paths[1] or 'boom'
  else
    timeout: Math.random() * 2
    name:    paths[0] or 'boom'

  sys.puts "GET $url.pathname"

  setTimeout (->
    res.writeHead 200
    res.end "$name in $timeout second(s)"
    ), timeout * 1000

server.listen port

sys.puts "Listening on :$port"
sys:   require 'sys'
http:  require 'http'
chain: require('chain-gang').create()
client: http.createClient 8080, 'localhost'

get_path: (path, cb) ->
  req: client.request('GET', path, {host: 'localhost'})
  req.end()
  req.addListener 'response', (resp) ->
    resp.addListener 'data', (chunk) ->
      sys.puts chunk
    resp.addListener 'end', cb

job: (timeout, name) ->
  (worker) ->
    get_path "/$timeout/$name", ->
      worker.finish()

chain.addListener 'add', (name) ->
  sys.puts "Adding job for $name"

chain.addListener 'starting', (name) ->
  sys.puts "Performing job for $name"

chain.addListener 'finished', (name) ->
  sys.puts "Finished $name"

# only the first job is completed since they all have the same names

chain.add job('1',   'dupe'), 'dupe'
chain.add job('0.1', 'dupe'), 'dupe'
chain.add job('0.1', 'dupe'), 'dupe'
chain.add job('0.1', 'dupe'), 'dupe'
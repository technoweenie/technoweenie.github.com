sys:   require 'sys'
http:  require 'http'
chain: require('chain-gang').create({workers: 2})
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

# the 3rd job waits on the first 2, since there are only 2 workers in the chain.

chain.add job('3',   'abc'), 'abc'
chain.add job('3',   'def'), 'def'
chain.add job('0.1', 'ghi'), 'ghi'
chain.add job('0.1', 'jkl'), 'jkl'
chain.add job('0.1', 'mno'), 'mno'
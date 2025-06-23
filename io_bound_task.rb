# io_bound_test.rb
require 'net/http'
require 'benchmark'
require 'json'

def send_metric_to_server(data)
  uri = URI('http://127.0.0.1:9394/submit')
  http = Net::HTTP.new(uri.host, uri.port)
  http.open_timeout = 5
  http.read_timeout = 5
  
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = data.to_json
  
  response = http.request(request)
  puts "Sent metric: #{response.code} #{response.message}"
rescue => e
  puts "Failed to send metric: #{e.message}"
end

def fetch_url(url)
  uri = URI(url)
  Net::HTTP.get(uri)
end

# Repeated URL calls to simulate I/O latency
URLS = Array.new(10, 'https://jsonplaceholder.typicode.com/posts/1')

puts "I/O-bound task benchmark: Threads vs Processes"

Benchmark.bm do |x|
  thread_result = x.report("Threads:") do
    threads = URLS.map do |url|
      Thread.new { fetch_url(url) }
    end
    threads.each(&:join)
  end

  process_result = x.report("Processes:") do
    pids = URLS.map do |url|
      fork do
        fetch_url(url)
        exit
      end
    end
    pids.each { |pid| Process.wait(pid) }
  end

  send_metric_to_server({
    type: "benchmark",
    mode: "io_threads",
    real: thread_result.real,
    utime: thread_result.utime,
    stime: thread_result.stime,
    total: thread_result.total
  })
  
  send_metric_to_server({
    type: "benchmark",
    mode: "io_processes",
    real: process_result.real,
    utime: process_result.utime,
    stime: process_result.stime,
    total: process_result.total
  })
end

puts "Check http://127.0.0.1:9394/metrics to see the results!" 
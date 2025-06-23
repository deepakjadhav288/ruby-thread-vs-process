# cpu_bound_test.rb
# wall clock as well as other times are good for processes
require 'benchmark'
require 'net/http'
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

def prime?(n)
  return false if n < 2
  (2..Math.sqrt(n)).none? { |i| n % i == 0 }
end

def count_primes(start_n, end_n)
  (start_n..end_n).count { |n| prime?(n) }
end

# Increased ranges to make the CPU work noticeable
WORKLOADS = [
  [10_000, 60_000],
  [60_001, 110_000],
  [110_001, 160_000],
  [160_001, 210_000]
]

puts "CPU-bound task benchmark: Threads vs Processes"

Benchmark.bm do |x|
  thread_result = x.report("Threads:") do
    threads = WORKLOADS.map do |range|
      Thread.new { count_primes(*range) }
    end
    threads.each(&:join)
  end

  process_result = x.report("Processes:") do
    pids = WORKLOADS.map do |range|
      fork do
        count_primes(*range)
        exit
      end
    end
    pids.each { |pid| Process.wait(pid) }
  end

  # Send metrics to our custom server
  send_metric_to_server({
    type: "benchmark",
    mode: "cpu_threads",
    real: thread_result.real,
    utime: thread_result.utime,
    stime: thread_result.stime,
    total: thread_result.total
  })
  
  send_metric_to_server({
    type: "benchmark",
    mode: "cpu_processes",
    real: process_result.real,
    utime: process_result.utime,
    stime: process_result.stime,
    total: process_result.total
  })
end

puts "Check http://127.0.0.1:9394/metrics to see the results!" 
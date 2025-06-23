# io_bound_test.rb
require 'net/http'
require 'benchmark'

def fetch_url(url)
  uri = URI(url)
  Net::HTTP.get(uri)
end

# Repeated URL calls to simulate I/O latency
URLS = Array.new(10, 'https://jsonplaceholder.typicode.com/posts/1')

puts "I/O-bound task benchmark: Threads vs Processes"

Benchmark.bm do |x|
  x.report("Threads:") do
    threads = URLS.map do |url|
      Thread.new { fetch_url(url) }
    end
    threads.each(&:join)
  end

  x.report("Processes:") do
    pids = URLS.map do |url|
      fork do
        fetch_url(url)
        exit
      end
    end
    pids.each { |pid| Process.wait(pid) }
  end
end 
# cpu_bound_test.rb
# wall clock as well as other times are good for processes
require 'benchmark'

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
  x.report("Threads:") do
    threads = WORKLOADS.map do |range|
      Thread.new { count_primes(*range) }
    end
    threads.each(&:join)
  end

  x.report("Processes:") do
    pids = WORKLOADS.map do |range|
      fork do
        count_primes(*range)
        exit
      end
    end
    pids.each { |pid| Process.wait(pid) }
  end
end 
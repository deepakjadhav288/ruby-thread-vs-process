# cpu_bound_test.rb
# wall clock time is good for thread but stil processes performed well in cpu usages
require 'benchmark'

def prime?(n)
  return false if n < 2
  (2..Math.sqrt(n)).none? { |i| n % i == 0 }
end

def count_primes(start_n, end_n)
  (start_n..end_n).count { |n| prime?(n) }
end

WORKLOADS = [
  [10_000, 20_000],
  [20_001, 30_000],
  [30_001, 40_000],
  [40_001, 50_000]
]

puts "Comparing threads vs processes for CPU-bound prime counting..."

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
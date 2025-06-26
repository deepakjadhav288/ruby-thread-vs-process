def race_with_mutex
  File.write("counter.txt", "0")
  mutex = Mutex.new

  threads = 10.times.map do |i|
    Thread.new do
      100.times do
        mutex.synchronize do
          current = File.read("counter.txt").to_i
          File.open("/dev/null", "w") { |f| f.write("dummy") }

          new_val = current + 1
          File.write("counter.txt", new_val.to_s)
        end
      end
    end
  end

  threads.each(&:join)
  puts "Final counter: #{File.read("counter.txt")}"
end

100.times { race_with_mutex }

require 'webrick'
require 'json'

class MetricsServer
  def initialize
    @metrics = {}
    @server = WEBrick::HTTPServer.new(Port: 9394, BindAddress: '0.0.0.0')
    
    @server.mount_proc '/metrics' do |req, res|
      res.content_type = 'text/plain'
      res.body = generate_prometheus_metrics
    end
    
    @server.mount_proc '/submit' do |req, res|
      if req.request_method == 'POST'
        begin
          data = JSON.parse(req.body)
          store_metric(data)
          res.status = 200
          res.body = 'OK'
        rescue => e
          res.status = 400
          res.body = "Error: #{e.message}"
        end
      else
        res.status = 405
        res.body = 'Method not allowed'
      end
    end
    
    trap('INT') { @server.shutdown }
  end
  
  def store_metric(data)
    puts "Received metric: #{data.inspect}"
    
    if data['type'] == 'benchmark'
      mode = data['mode']
      
      ['real', 'utime', 'stime', 'total'].each do |metric_type|
        if data[metric_type]
          metric_name = "benchmark_#{metric_type}_time"
          labels = { mode: mode }
          value = data[metric_type]
          
          @metrics[metric_name] ||= {}
          @metrics[metric_name][labels] = value
          
          puts "Stored metric: #{metric_name} = #{value} with labels #{labels}"
        end
      end
    end
  end
  
  def generate_prometheus_metrics
    output = []
    
    @metrics.each do |metric_name, label_values|
      case metric_name
      when /real_time/
        output << "# HELP #{metric_name} Wall clock execution time in seconds"
      when /utime/
        output << "# HELP #{metric_name} CPU time in user mode in seconds"
      when /stime/
        output << "# HELP #{metric_name} CPU time in system/kernel mode in seconds"
      when /total/
        output << "# HELP #{metric_name} Total CPU time in seconds"
      end
      
      output << "# TYPE #{metric_name} gauge"
      
      label_values.each do |labels, value|
        label_str = labels.map { |k, v| "#{k}=\"#{v}\"" }.join(',')
        output << "#{metric_name}{#{label_str}} #{value}"
      end
      
      output << ""
    end
    
    output.join("\n")
  end
  
  def start
    puts "Starting metrics server on http://localhost:9394"
    puts "Metrics endpoint: http://localhost:9394/metrics"
    puts "Submit endpoint: http://localhost:9394/submit"
    @server.start
  end
end

MetricsServer.new.start 
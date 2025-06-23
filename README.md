# Ruby Observability Demo App

A comprehensive Ruby application demonstrating observability patterns with Sidekiq, Prometheus metrics, and memory profiling.

## Features

- **Sidekiq**: Background job processing with Redis
- **Prometheus Metrics**: Custom metrics collection and export
- **Memory Profiling**: Memory usage analysis and optimization
- **Structured Logging**: JSON-formatted logs for better parsing
- **Performance Monitoring**: CPU and memory profiling tools

## Setup

### Prerequisites

- Ruby 3.2.1
- Redis server
- Bundler

### Installation

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Start Redis:**
   ```bash
   redis-server
   ```

3. **Start the Prometheus metrics exporter:**
   ```bash
   bundle exec ruby prometheus_exporter.rb
   ```

4. **Start Sidekiq worker:**
   ```bash
   bundle exec sidekiq -r ./config/sidekiq.rb
   ```

5. **Run the application:**
   ```bash
   bundle exec ruby app.rb
   ```

## Usage

### Triggering Jobs

```ruby
# In IRB or your application
require './app'
require './workers/sample_worker'

# Enqueue a job
SampleWorker.perform_async("test_data")

# Enqueue a memory-intensive job
MemoryIntensiveWorker.perform_async("large_dataset")
```

### Memory Profiling

```ruby
# Profile memory usage
require './lib/memory_profiler_helper'

MemoryProfilerHelper.profile do
  # Your code here
  SampleWorker.new.perform("test")
end
```

### Viewing Metrics

- **Prometheus metrics**: http://localhost:9394/metrics
- **Sidekiq web UI**: http://localhost:8080

## Project Structure

```
ruby_observability_app/
├── app.rb                    # Main application entry point
├── config/
│   ├── sidekiq.rb           # Sidekiq configuration
│   └── prometheus.rb        # Prometheus configuration
├── workers/
│   ├── sample_worker.rb     # Basic worker example
│   └── memory_worker.rb     # Memory-intensive worker
├── lib/
│   ├── memory_profiler_helper.rb
│   └── metrics_helper.rb
├── prometheus_exporter.rb   # Prometheus metrics server
└── Gemfile
```

## Monitoring

### Metrics Available

- `sidekiq_jobs_total`: Total number of jobs processed
- `sidekiq_job_duration_seconds`: Job execution time
- `memory_usage_bytes`: Memory usage per job
- `redis_connections`: Active Redis connections

### Logs

All logs are in JSON format for easy parsing and analysis.

## Development

### Running Tests

```bash
bundle exec rspec
```

### Code Quality

```bash
bundle exec rubocop
```

## Troubleshooting

1. **Redis connection issues**: Ensure Redis is running on localhost:6379
2. **Port conflicts**: Change ports in configuration files if needed
3. **Memory issues**: Use memory profiling tools to identify bottlenecks 
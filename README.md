# Ruby Thread vs Process Analysis Demo App

A Ruby application demonstrating the performance differences between threads and processes for different types of workloads through benchmarking, memory profiling, and observability.

## What This Repository Contains

This repository contains Ruby scripts that benchmark and analyze the performance characteristics of threads vs processes for different workload types:

### **CPU-Bound Tasks**
- `cpu_bound_task.rb` - CPU-intensive prime number calculations

### **I/O-Bound Tasks**
- `io_bound_task.rb` - HTTP request benchmarking using external API calls

### **Observability**
- `basic_metrics_server.rb` - Custom Prometheus-compatible metrics server

### **Analysis Documentation**
- `io_bound_task_benchmark.md` - Detailed analysis of I/O-bound task results
- `cpu_bound_task_benchmark.md` - Detailed analysis of CPU-bound task results

## Key Findings

### **I/O-Bound Tasks (Threads Win)**
- Threads are **10.6% faster** than processes for HTTP requests (0.478s vs 0.432s)
- Lower CPU overhead and resource usage
- Better suited for network operations, database queries, file I/O

### **CPU-Bound Tasks (Processes Win)**
- Processes are **136.8% faster** than threads for CPU-intensive calculations (0.309s vs 0.732s)
- True parallelism bypasses Ruby's Global Interpreter Lock (GIL)
- Better utilization of multiple CPU cores

## Prerequisites

- Ruby 3.2.1 or higher
- Internet connection (for I/O-bound task testing)

## Quick Start Guide

### Step 1: Install Dependencies
```bash
# Install required gems
bundle install
```

### Step 2: Start the Prometheus Metrics Server
```bash
# Start the metrics server in a separate terminal window
ruby basic_metrics_server.rb
```

**What this does:**
- Starts a web server on `http://localhost:9394`
- Creates two endpoints:
  - `/metrics` - Prometheus-compatible metrics endpoint
  - `/submit` - Endpoint for receiving benchmark data

**Expected output:**
```
Starting metrics server on http://localhost:9394
Metrics endpoint: http://localhost:9394/metrics
Submit endpoint: http://localhost:9394/submit
```

### Step 3: Run Benchmark Scripts

Open a **new terminal window** (keep the metrics server running) and run:

#### CPU-Bound Task Benchmark
```bash
ruby cpu_bound_task.rb
```

#### I/O-Bound Task Benchmark
```bash
ruby io_bound_task.rb
```

### Step 4: View Results in Your Browser

#### Option 1: View Raw Metrics Data
Open your browser and go to: **http://localhost:9394/metrics**

You'll see Prometheus-formatted metrics like:
```
# HELP benchmark_real_time Wall clock execution time in seconds
# TYPE benchmark_real_time gauge
benchmark_real_time{mode="cpu_threads"} 0.732
benchmark_real_time{mode="cpu_processes"} 0.309
benchmark_real_time{mode="io_threads"} 0.478
benchmark_real_time{mode="io_processes"} 0.432

# HELP benchmark_utime CPU time in user mode in seconds  
# TYPE benchmark_utime gauge
benchmark_utime{mode="cpu_threads"} 0.695
benchmark_utime{mode="cpu_processes"} 1.156
```

#### Option 2: Monitor in Real-Time
1. Keep the metrics server running
2. Run benchmark scripts multiple times
3. Refresh the browser page to see updated metrics
4. Compare the performance differences between threads and processes

## Understanding the Results

### **Key Metrics Explained**
- **`benchmark_real_time`** - Wall clock time (actual time elapsed)
- **`benchmark_utime`** - CPU time spent in user mode
- **`benchmark_stime`** - CPU time spent in system/kernel mode
- **`benchmark_total`** - Total CPU time (utime + stime)

### **Mode Labels**
- **`cpu_threads`** - CPU-bound task using threads
- **`cpu_processes`** - CPU-bound task using processes
- **`io_threads`** - I/O-bound task using threads
- **`io_processes`** - I/O-bound task using processes

### **Performance Patterns**
- **CPU-bound tasks**: Processes typically outperform threads (bypasses Ruby GIL)
- **I/O-bound tasks**: Threads typically outperform processes (lower overhead)

## Advanced Usage

### Integration with Prometheus
To scrape these metrics with Prometheus, add this target to your `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'ruby-benchmarks'
    static_configs:
      - targets: ['localhost:9394']
```



## Troubleshooting

### Common Issues

**Port 9394 already in use:**
```bash
# Find and kill the process using port 9394
lsof -ti:9394 | xargs kill -9
```

**Connection refused when running benchmarks:**
- Make sure the metrics server is running first
- Check that http://localhost:9394 is accessible in your browser

**Metrics not updating:**
- Refresh the browser page manually
- Run the benchmark scripts again to generate new data

## Key Insights

### **When to Use Threads**
- I/O-bound operations (HTTP requests, database queries)
- Network services and API calls
- File operations with waiting time
- Web servers and API clients

### **When to Use Processes**
- CPU-intensive calculations
- Large dataset processing
- Mathematical computations
- When true parallelism is required
- When memory isolation is critical

## Project Structure

```
observability_demo/
├── cpu_bound_task.rb              # CPU benchmarking
├── io_bound_task.rb               # I/O benchmarking
├── basic_metrics_server.rb        # Custom metrics server
├── io_bound_task_benchmark.md     # I/O analysis
├── cpu_bound_task_benchmark.md    # CPU analysis
├── Gemfile                        # Ruby dependencies
├── README.md                      # This file
└── .gitignore                     # Git ignore patterns
```

## Observability Features

- **Real-time Metrics**: Live performance data via HTTP endpoint
- **Prometheus Compatibility**: Standard metrics format for integration
- **Benchmark Comparison**: Side-by-side thread vs process performance

## Integration with Monitoring Tools

The metrics endpoint can be scraped by:
- **Prometheus**: Add target `localhost:9394` to scrape configuration
- **Custom Monitoring**: Any tool that supports Prometheus format

## Contributing

Feel free to add more benchmarking scenarios or improve the analysis. This repository serves as a practical demonstration of Ruby concurrency patterns, memory profiling, and observability practices. 
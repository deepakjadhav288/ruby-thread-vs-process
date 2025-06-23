# Ruby Thread vs Process Analysis Demo App

A Ruby application demonstrating the performance differences between threads and processes for different types of workloads through benchmarking and detailed analysis.

## What This Repository Contains

This repository contains Ruby scripts that benchmark and analyze the performance characteristics of threads vs processes for different workload types:

### **CPU-Bound Tasks**
- `cpu_bound_task.rb` - CPU-intensive prime number calculations

### **I/O-Bound Tasks**
- `io_bound_task.rb` - HTTP request benchmarking using external API calls

### **Analysis Documentation**
- `io_bound_task_benchmark.md` - Detailed analysis of I/O-bound task results
- `cpu_bound_task_benchmark.md` - Detailed analysis of CPU-bound task results

## Key Findings

### **I/O-Bound Tasks (Threads Win)**
- Threads are **47.6% faster** than processes for HTTP requests
- Lower CPU overhead and resource usage
- Better suited for network operations, database queries, file I/O

### **CPU-Bound Tasks (Processes Win)**
- Processes are **136.8% faster** than threads for CPU-intensive calculations
- True parallelism bypasses Ruby's Global Interpreter Lock (GIL)
- Better utilization of multiple CPU cores

## Prerequisites

- Ruby 3.2.1 or higher
- Internet connection (for I/O-bound task testing)

## How to Clone and Run

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/ruby_observability_app.git
cd ruby_observability_app
```

### 2. Run the Benchmarking Scripts

#### **CPU-Bound Task**
```bash
ruby cpu_bound_task.rb
```

#### **I/O-Bound Task**
```bash
ruby io_bound_task.rb
```

### 3. View the Analysis
After running the scripts, you can review the detailed analysis in:
- `io_bound_task_benchmark.md` - I/O-bound task analysis
- `cpu_bound_task_benchmark.md` - CPU-bound task analysis

## Understanding the Results

### **Benchmark Output Format**
Each script outputs `Benchmark::Tms` objects with:
- `@real` - Wall clock time (actual elapsed time)
- `@utime` - CPU time in user mode
- `@stime` - CPU time in system/kernel mode
- `@cutime` - CPU time in user mode (children processes)
- `@cstime` - CPU time in system/kernel mode (children processes)
- `@total` - Total CPU time

### **What to Look For**
- **Wall clock time (@real)**: Shows actual performance difference
- **CPU utilization**: Shows how efficiently resources are used
- **Child process time**: Shows work distribution in process-based approaches

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
ruby_observability_app/
├── cpu_bound_task.rb              # CPU benchmarking
├── io_bound_task.rb               # I/O benchmarking
├── io_bound_task_benchmark.md     # I/O analysis
├── cpu_bound_task_benchmark.md    # CPU analysis
├── README.md                      # This file
└── .gitignore                     # Git ignore patterns
```

## Contributing

Feel free to add more benchmarking scenarios or improve the analysis. This repository serves as a practical demonstration of Ruby concurrency patterns and their performance characteristics. 
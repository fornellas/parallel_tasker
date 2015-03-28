# parallel_tasker
Small Ruby Gem to run tasks in parallel.

This is useful when you wish to parallelize tasks and wish to have a concurrency limit, and does not want to deal with Thread synchronization.

# Example

## With block (recommended)

### Processing each task return

```ruby
require 'parallel_tasker'

concurrency = 2
number_of_tasks = 5

# Creates a new object
ParallelTasker.new(concurrency) do |pt|
  # Add tasks
  (1..number_of_tasks).each do |id|
    pt.add_task(id) do
      puts "#{id}: Starting..."
      sleep id
      # Let's raise on last task
      if id == number_of_tasks
        raise "Exception at task #{id}!"
      end
      puts "#{id}: Finished!"
      id
    end
  end

  # Run all tasks (this will block until last thread finishes)
  puts 'Running all tasks.'
  statuses = pt.run
  puts 'Finished all tasks.'
  puts

  # Get each task status.
  puts "Returns"
  statuses.each do |id, thread|
    print "#{id}: "
    message = begin
      "Returned: #{thread.value.to_s}"
    rescue
      "Raised #{$!.class}: #{$!}"
    end
    puts message
  end
end
```

### Ignoring all tasks return

```ruby
require 'parallel_tasker'

concurrency = 2
number_of_tasks = 5

# Creates a new object
ParallelTasker.new(concurrency) do |pt|
  # Add tasks
  (1..number_of_tasks).each do |id|
    pt.add_task(id) do
      puts "#{id}: Starting..."
      sleep id
      # Let's raise on last task
      if id == number_of_tasks
        raise "Exception at task #{id}!"
      end
      puts "#{id}: Finished!"
      id
    end
  end
```

## Without block

```ruby
require 'parallel_tasker'

concurrency = 2
number_of_tasks = 5

# Creates a new object
pt = ParallelTasker.new(concurrency)

# Add tasks
(1..number_of_tasks).each do |id|
  pt.add_task(id) do
    puts "#{id}: Starting..."
    sleep id
    # Let's raise on last task
    if id == number_of_tasks
      raise "Exception at task #{id}!"
    end
    puts "#{id}: Finished!"
    id
  end
end

# Run all tasks (this will block until last thread finishes)
puts 'Running all tasks.'
statuses = pt.run
puts 'Finished all tasks.'
puts

# Get each task status.
puts "Returns"
statuses.each do |id, thread|
  print "#{id}: "
  message = begin
    "Returned: #{thread.value.to_s}"
  rescue
    "Raised #{$!.class}: #{$!}"
  end
  puts message
end
```
# parallel_tasker
Small Ruby Gem to run tasks in parallel.

# Example

You create a new object, telling how many tasks to allow in parallel. Then, use #add_task, with an id, and a block, with a new task. Call #run, which run all therads, and returns a Hash, with all finished threads, from where you can join each one of them.

```ruby
require 'parallel_tasker'

max_parallel = 2
number_of_tasks = 5

pt = ParallelTasker.new max_parallel

(1..number_of_tasks).each do |id|
  pt.add_task(id) do
    puts "start #{id}"
    sleep id
    if id == number_of_tasks
      raise "Exception at last thread!"
    end
    puts "end #{id}"
  end
end

pt.run.each do |id, thread|
  puts "joining #{id}"
  thread.join
end

```
  

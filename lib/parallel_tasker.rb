require 'thwait'

require_relative 'parallel_tasker/task'

# Run tasks in parallel threads
class ParallelTasker
 
  # Set max number of parallel threads.
  # Yields self to block, if given.
  # Unless block calls #run, it is called automatically.
  def initialize concurrency
    @concurrency = concurrency
    @tasks_queue = Queue.new
    @already_run = false
    if block_given?
      yield self
      self.run unless @already_run
    end
  end
 
  # Add task to be executed.
  def add_task id, &block
    @tasks_queue << Task.new(id, &block)
  end

  alias_method :<<, :add_task

  class DoubleRun < RuntimeError ; end
 
  # Execute all tasks in separate threads, with maximum asked concurrency of parallel
  # threads.
  # Returns a Hash with all given id as keys, and its value are threads
  # themselves. User can use Thread class methods to verify each task state, such as Thread#join.
  def run
    raise DoubleRun.new('#run called more than one time') if @already_run
    @already_run = true
    @result = {}
    processor_threads = []
    @concurrency.times do
      processor_threads << new_processor_thread
    end
    processor_threads.each{|t| t.join }
    @result
  end

  private

  def new_processor_thread
    Thread.new do
      until @tasks_queue.empty?
        task = @tasks_queue.pop
        thread = Thread.new{task.block.call}
        @result[task.id] = thread
        begin
          thread.join
        rescue
        end
      end
    end
  end
 
end

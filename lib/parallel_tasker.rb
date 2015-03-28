require 'thwait'

# Run tasks in parallel threads
class ParallelTasker
 
  # Set max number of parallel threads.
  # Yields self to block, if given.
  # Unless block calls #run, it is called automatically.
  def initialize concurrency
    @concurrency = concurrency
    @tasks = {}
    @already_run = false
    if block_given?
      yield self
      self.run unless @already_run
    end
  end
 
  # Add task to be executed.
  def add_task id, &task
    @tasks[id] = task
  end

  alias_method :<<, :add_task

  # Return block for task with given id
  def task id
    @tasks[id]
  end

  class DoubleRun < RuntimeError ; end
 
  # Execute all tasks in separate threads, with maximum asked concurrency of parallel
  # threads.
  # Returns a Hash with all given id as keys, and its value are threads
  # themselves. User can use Thread class methods to verify each task state, such as Thread#join.
  def run
    raise DoubleRun.new('#run called more than one time') if @already_run
    @already_run = true
    @threads = {}
    @concurrency = @tasks.size if @concurrency > @tasks.size
    pending_ids = @tasks.keys
    @already_running_ids = []
    completed_ids = []
    # start initial batch
    pending_ids.shift(@concurrency).each{|id| new_thread(id)}
    # wait for termination
    twait = ThreadsWait.new(*running_threads)
    twait.all_waits do |finished_thread|
      # update arrays
      completed_id = @threads.key(finished_thread)
      @already_running_ids.delete completed_id
      completed_ids << completed_id
      # start new thread if available and below concurrency
      if not pending_ids.empty? and @already_running_ids.size < @concurrency
        new_id = pending_ids.shift
        new_thread new_id
        twait.join_nowait *running_threads
      end
    end
    @threads
  end
 
  private
 
  # Create a new thread based on given id
  def new_thread id
    @threads[id] = Thread.new &@tasks[id]
    @already_running_ids << id
  end
 
  # return array of all running threads
  def running_threads
    rt = []
    @already_running_ids.each do |id|
      rt << @threads[id]
    end
    rt
  end
end

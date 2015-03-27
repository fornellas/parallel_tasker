require 'thwait'

# Run tasks in parallel threads
class ParallelTasker
 
  # Set max number of parallel threads
  def initialize limit
    @limit = limit
    @tasks = {}
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
 
  # Execute all tasks in separate threads, with maximum asked limit of parallel
  # threads.
  # Returns a Hash with all given id as keys, and its value are threads
  # themselves. User can run Thread#status to see if it terminated with an
  # exception (nil) or not (false), and Thread#value to get either its return
  # value or returned exception.
  def run
    @threads = {}
    @limit = @tasks.size if @limit > @tasks.size
    pending_ids = @tasks.keys
    @running_ids = []
    completed_ids = []
    # start initial batch
    pending_ids.shift(@limit).each{|id| new_thread(id)}
    # wait for termination
    twait = ThreadsWait.new(*running_threads)
    twait.all_waits do |finished_thread|
      # update arrays
      completed_id = @threads.key(finished_thread)
      @running_ids.delete completed_id
      completed_ids << completed_id
      # start new thread if available and below limit
      if not pending_ids.empty? and @running_ids.size < @limit
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
    @running_ids << id
  end
 
  # return array of all running threads
  def running_threads
    rt = []
    @running_ids.each do |id|
      rt << @threads[id]
    end
    rt
  end
end

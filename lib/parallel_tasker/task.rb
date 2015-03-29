class ParallelTasker
  # Task to be run
  class Task

    attr_accessor :id, :block

    # Raised when no block was given
    class NoBlockGiven < RuntimeError ; end

    # Receive a task id, an a block with the task
    def initialize id, &block
      raise NoBlockGiven.new("No block given") unless block
      @id = id
      @block = block
    end

  end
end
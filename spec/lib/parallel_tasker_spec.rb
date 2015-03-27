require 'parallel_tasker'

RSpec.describe ParallelTasker do
  
  let(:limit){2}
  
  subject do
    ParallelTasker.new(limit)
  end

  context '#add_task, #task' do
    it 'adds and retrieve tasks' do
      id = :empty_block
      block = proc{}
      subject.add_task id, &block
      expect(subject.task id).to eq(block)
    end
  end

  context '#run' do

    let(:max_tasks){5}
    
    it 'runs all tasks' do
      task_run = {}
      (0...max_tasks).each do |id|
        subject.add_task(id) do
          task_run[id] = true
        end
      end
      subject.run
      (0...max_tasks).each do |id|
        expect(task_run[id]).to eq(true)
      end
    end

    it 'respects parallelism' do
      parallelism = 0
      (0...max_tasks).each do |id|
        subject.add_task(id) do
          parallelism += 1
          expect(parallelism).to be <= limit
          sleep id
          parallelism -=1
        end
      end
      subject.run
      pending_tasks = parallelism
      expect(pending_tasks).to eq(0)
    end

  end
end
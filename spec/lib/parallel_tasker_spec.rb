require 'parallel_tasker'

RSpec.describe ParallelTasker do
  
  let(:concurrency){2}
  
  subject do
    ParallelTasker.new(concurrency)
  end

  context '#initialize' do

    context 'block_given' do

      it 'yields self' do
        yielded_obj = nil
        pt = ParallelTasker.new(concurrency){|i| yielded_obj = i}
        expect(yielded_obj).to eq(pt)
      end

      it 'calls #run if not called inside block' do
        expect_any_instance_of(ParallelTasker).to receive(:run)
        ParallelTasker.new(concurrency) do |pt|
          pt.add_task(:task){}
        end
      end

      it 'does not call #run if already called inside block' do
        expect_any_instance_of(ParallelTasker).to receive(:run).and_wrap_original do |m|
          m.call
        end
        ParallelTasker.new(concurrency) do |pt|
          pt.add_task(:task){}
          pt.run
        end
      end
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

    it 'respects concurrency' do
      parallelism = 0
      (0...max_tasks).each do |id|
        subject.add_task(id) do
          parallelism += 1
          expect(parallelism).to be <= concurrency
          sleep id
          parallelism -=1
        end
      end
      subject.run
      pending_tasks = parallelism
      expect(pending_tasks).to eq(0)
    end

    it 'returns result hash' do
      subject.add_task(:raise) do
        raise
      end
      subject.add_task(:true) do
        true
      end
      result = subject.run
      expect do
        result[:raise].value
      end.to raise_error
      expect(result[:true].value).to eq(true)
    end

  end
end
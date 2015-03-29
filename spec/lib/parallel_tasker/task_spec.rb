require 'parallel_tasker/task'

RSpec.describe ParallelTasker::Task do

  let(:id) { :task_id }
  let(:block) { proc {} }

  subject do
    ParallelTasker::Task.new(id, &block) 
  end

  context '#initialize' do
    
    it 'raises NoBlockGiven if no block was given' do
      expect do
        ParallelTasker::Task.new(id)
      end.to raise_error(ParallelTasker::Task::NoBlockGiven)
    end
    
  end


  it 'has id and block attributes' do
    expect(subject).to have_attributes(id: id, block: block)
  end
  
end
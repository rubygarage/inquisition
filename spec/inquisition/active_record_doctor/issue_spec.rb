RSpec.describe Inquisition::ActiveRecordDoctor::Issue do
  describe '#to_h' do
    subject(:vulnerability) { described_class.new(task, 'table', ['column#1', 'column#2']) }

    let(:task) { ActiveRecordDoctor::Tasks::UnindexedForeignKeys }
    let(:message) { 'table has unindexed foreign keys, details: column#1, column#2' }

    let(:options) do
      {
        category: Inquisition::ActiveRecordDoctor::Runner::TASKS[task],
        severity: Inquisition::Severity::LOW,
        path: nil,
        line: nil,
        message: message
      }
    end

    it { expect(vulnerability.to_h).to include(options) }
  end
end

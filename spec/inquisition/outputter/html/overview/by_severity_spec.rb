RSpec.describe Inquisition::Outputter::HTML::Overview::BySeverity do
  describe '#breakdown' do
    subject(:by_category) { described_class.new([issue]) }

    let(:issue) do
      Inquisition::Issue.new(
        path: 'app/controllers/users_controller.rb',
        line: 42,
        severity: Inquisition::Severity::HIGH,
        message: 'Potentially dangerous key allowed for mass assignment',
        category: Inquisition::Category::SECURITY,
        runner: Inquisition::Brakeman::Runner.new,
        aditional_data: nil
      )
    end

    it 'returns array of percentage for each severity' do
      expect(by_category.breakdown).to match_array([0.0, 0.0, 100.0])
    end
  end

  describe '#produce' do
    subject(:by_category) { described_class.new([]) }

    it { expect(by_category.produce).to be_an_instance_of(Binding) }
  end
end

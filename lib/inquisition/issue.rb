module Inquisition
  class Issue
    COMPARISON_ATTRIBUTES = %i[path line severity message category].freeze

    attr_reader :path, :line, :severity, :message, :category, :runner, :aditional_data

    def initialize(path:, line:, severity:, message:, category:, runner:, aditional_data: nil)
      @path = path
      @line = line
      @runner = runner
      @message = message
      @severity = Severity.new(severity)
      @category = Category.new(category)
      @aditional_data = aditional_data
    end

    def ==(other)
      COMPARISON_ATTRIBUTES.all? do |attribute|
        send(attribute) == other.send(attribute)
      end
    end

    alias eql? ==

    def hash
      COMPARISON_ATTRIBUTES.reduce(0) do |hash, attribute|
        hash ^ send(attribute).hash
      end
    end
  end
end

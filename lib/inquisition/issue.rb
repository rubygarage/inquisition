module Inquisition
  class Issue
    COMPARISON_ATTRIBUTES = %i[path line severity message category].freeze

    attr_reader :path, :line, :severity, :message, :category, :runner

    def initialize(path:, line:, severity:, message:, runner:, category:)
      @path = path
      @line = line
      @runner = runner
      @message = message
      @severity = Severity.new(severity)
      @category = Category.new(category)
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

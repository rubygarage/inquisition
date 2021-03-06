module Inquisition
  module Outputter
    class Progress
      Outputter.declare(self, :example_passed, :example_failed, :stop)

      def initialize(output = StringIO.new)
        @output = output
      end

      def example_passed(_payload)
        output.print("\e[32m.\e[0m")
      end

      def example_failed(_payload)
        output.print("\e[31mF\e[0m")
      end

      def stop(_payload)
        output.puts
      end

      private

      attr_reader :output
    end
  end
end

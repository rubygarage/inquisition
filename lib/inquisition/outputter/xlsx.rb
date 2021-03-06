require_relative 'xlsx/builder'

module Inquisition
  module Outputter
    class Xlsx
      Outputter.declare(self, :stop)

      def initialize(_output); end

      def stop(issues)
        Builder.call(issues)
      end
    end
  end
end

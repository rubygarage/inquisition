module Inquisition
  module Formatters
    module HTML
      module Overview
        class CoverageBuilder < Builder
          def file_name
            'coverage.html'
          end
        end
      end
    end
  end
end
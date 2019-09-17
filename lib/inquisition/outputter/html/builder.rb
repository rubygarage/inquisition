module Inquisition
  module Outputter
    class HTML
      class Builder
        def initialize(collection)
          @collection = collection
        end

        def render
          ERB.new(File.read(template_path)).result(binding)
        end

        def file_path
          File.join(Rails.root, 'inquisition', file_name)
        end

        private

        attr_reader :collection

        def template_path
          File.join(Inquisition.root, 'views', "#{file_name}.erb")
        end

        def file_name
          raise NotImplementedError
        end
      end
    end
  end
end

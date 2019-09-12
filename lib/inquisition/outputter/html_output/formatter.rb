require 'fileutils'
require_relative 'builder'
require_relative 'overview_builder'
require_relative 'issues_list_builder'

module Inquisition
  module Outputter
    module HtmlOutput
      class Formatter
        def initialize(collection)
          @collection = collection
        end

        def call
          create_directories
          copy_assets
          create_files
        end

        private

        def create_directories
          FileUtils.mkdir_p(report_directory)
        end

        def copy_assets
          FileUtils.cp_r(assets_directory, report_directory)
        end

        def create_files
          generators.each do |generator|
            File.open(generator.file_path, 'w+') do |file|
              file.write(generator.render)
            end
          end
        end

        def generators
          [
            IssuesListBuilder.new(@collection),
            OverviewBuilder.new(@collection)
          ]
        end

        def assets_directory
          File.join(Inquisition.root, 'assets')
        end

        def report_directory
          File.join(Rails.root, 'inquisition')
        end
      end
    end
  end
end

module Inquisition
  module Core
    module Presenters
      module Data
        module Common
          class RoutesPresenter < Presenters::StaticPresenter
            COMMAND = 'rake routes'.freeze
            attr_reader :raw_data

            def initialize
              @raw_data = run_cli(COMMAND)
            end

            private

            def build_presenter
              @build_presenter ||= splited_data.map do |route_summary|
                prefix, verb, uri, pattern = prepare_route(route_summary)
                {
                  prefix: prefix,
                  verb: verb,
                  uri: uri,
                  pattern: pattern
                }
              end
            end

            def prepare_route(route)
              return route if route.size >= 4

              route.prepend('-')
            end

            def splited_data
              @raw_data.split("\n").map(&:split).reject(&:empty?).tap(&:shift)
            end
          end
        end
      end
    end
  end
end

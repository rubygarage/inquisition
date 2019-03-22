module Inquisition
  module Core
    module Presenters
      class DatabaseLintersPresenter < BasePresenter
        DATABASE_SCHEMA_FILE = 'db/schema.rb'.freeze
        NESTED_LINTERS = [:active_record_doctor].freeze
        DATABASE_LINTERS = %i[
          active_record_doctor
          lol_dba
        ].freeze

        def repeated_indexes_percentage
          100 * database_auditors.dig(:extraneous_indexes, :total_files).to_i / tables_count
        end

        def missing_foreign_keys_percentage
          100 * database_auditors.dig(:missing_foreign_keys, :total_files).to_i / tables_count
        end

        def incompatibility_structure_with_models_percentage
          ((database_auditors.dig(:missing_foreign_keys, :errors) || []) +
           (database_auditors.dig(:missing_presence_validation, :errors) || []) +
           (database_auditors.dig(:missing_unique_indexes, :errors) || []) +
           (database_auditors.dig(:undefined_table_references, :errors) || [])).count
        end

        def unindexed_foreign_keys_percentage
          ((database_auditors.dig(:unindexed_foreign_keys, :errors) || []) +
           (database_auditors.dig(:lol_dba, :errors) || [])).count
        end

        def top_tables_with_errors(number)
          database_auditors.values.map { |value| value[:errors] }.flatten
                           .group_by { |error| error[:table] }.map(&method(:tables_with_errors_hash))
                           .sort_by { |table| table[:errors_count] }.reverse.first(number)
        end

        def top_types_of_errors(_number)
          database_auditors.values.map { |value| value[:errors] }.flatten.group_by { |error| error[:type] }
                           .map { |name, value| { name => value.count } }.sort_by(&:values)
                           .each_with_index.map(&method(:build_types_of_error_hash))
        end

        def total_errors
          @total_errors ||= database_auditors.values.map { |auditor| auditor.dig(:total_files) }.compact.sum
        end

        def tables_count
          @tables_count ||= File.foreach(File.join(Dir.pwd, DATABASE_SCHEMA_FILE)).grep(/create_table/).count
        end

        def included_linters_count
          database_auditors.count
        end

        private

        def database_auditors
          @database_auditors ||= @data.dig(:backend).slice(*DATABASE_LINTERS).tap do |obj|
            obj.merge!(obj.delete(:active_record_doctor)) if obj.dig(:active_record_doctor)
          end
        end

        def build_types_of_error_hash(error, index)
          {
            error_name: error.keys.first,
            tables_count: error.values.first,
            chart_color: CIRCLE_CHART_COLORS[index]
          }
        end

        def tables_with_errors_hash(table_name, errors)
          error_count = errors.count
          {
            table_name: table_name,
            error_count: error_count,
            total_errors_percent: error_percent(error_count)
          }
        end

        def error_percent(error_count)
          100 * error_count.to_i / total_errors.to_i
        end
      end
    end
  end
end

module Inquisition
  module Core
    module Builders
      module Html
        class DatabaseSummaryPageBuilder < Core::Builders::BaseHtmlBuilder
          TEMPLATE = 'pages/database_summary.html.haml'.freeze
          PAGE_PRESENTER = Core::Presenters::Pages::Html::DatabaseSummaryPagePresenter
        end
      end
    end
  end
end
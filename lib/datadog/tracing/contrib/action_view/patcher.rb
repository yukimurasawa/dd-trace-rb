# typed: true

require 'datadog/core'
require 'datadog/tracing/contrib/patcher'
require 'datadog/tracing/contrib/action_view/events'
require 'datadog/tracing/contrib/action_view/ext'
require 'datadog/tracing/contrib/action_view/instrumentation/partial_renderer'
require 'datadog/tracing/contrib/action_view/instrumentation/template_renderer'
require 'datadog/tracing/contrib/action_view/utils'

module Datadog
  module Tracing
    module Contrib
      module ActionView
        # Patcher enables patching of ActionView module.
        module Patcher
          include Contrib::Patcher

          module_function

          def target_version
            Integration.version
          end

          def patch
            patch_renderer
          end

          def patch_renderer
            if target_version >= Gem::Version.new('4.0.0')
              Events.subscribe!
            elsif defined?(::ActionView::TemplateRenderer) && defined?(::ActionView::PartialRenderer)
              # Rails < 4.0 compatibility:
              #  Rendering events are not nested in this version, creating
              #  render_partial spans outside of the parent render_template span.
              #  We fall back to manual patching instead.
              ::ActionView::TemplateRenderer.prepend(Instrumentation::TemplateRenderer::RailsLessThan4)
              ::ActionView::PartialRenderer.prepend(Instrumentation::PartialRenderer::RailsLessThan4)
            else
              Datadog.logger.debug('Expected Template/Partial classes not found; template rendering disabled')
            end
          end
        end
      end
    end
  end
end

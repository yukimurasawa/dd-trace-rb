require 'datadog/tracing/distributed/headers/ext'
require 'datadog/tracing/distributed/metadata/parser'

module Datadog
  module Tracing
    module Distributed
      module Metadata
        # Datadog provides helpers to inject or extract metadata for Datadog style headers
        class Datadog
          include Distributed::Headers::Ext

          def self.inject!(digest, metadata)
            return if digest.nil?

            metadata[GRPC_METADATA_TRACE_ID] = digest.trace_id.to_s
            metadata[GRPC_METADATA_PARENT_ID] = digest.span_id.to_s
            if digest.trace_sampling_priority
              metadata[GRPC_METADATA_SAMPLING_PRIORITY] =
                digest.trace_sampling_priority.to_s
            end
            metadata[GRPC_METADATA_ORIGIN] = digest.trace_origin.to_s if digest.trace_origin

            metadata
          end

          def self.extract(metadata)
            carrier = Carrier.new(metadata)

            return nil unless carrier.valid?

            TraceDigest.new(
              span_id: carrier.parent_id,
              trace_id: carrier.trace_id,
              trace_origin: carrier.origin,
              trace_sampling_priority: carrier.sampling_priority
            )
          end

          # opentracing.io compliant carrier object
          class Carrier
            include Distributed::Headers::Ext

            def initialize(metadata = {})
              @metadata = Parser.new(metadata || {})
            end

            def valid?
              (trace_id && parent_id) || (origin && trace_id)
            end

            def trace_id
              @metadata.id(GRPC_METADATA_TRACE_ID)
            end

            def parent_id
              @metadata.id(GRPC_METADATA_PARENT_ID)
            end

            def sampling_priority
              value = @metadata.metadata_for_key(GRPC_METADATA_SAMPLING_PRIORITY)
              value && value.to_i
            end

            def origin
              value = @metadata.metadata_for_key(GRPC_METADATA_ORIGIN)
              value if value != ''
            end
          end
        end
      end
    end
  end
end

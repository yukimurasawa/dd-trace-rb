# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ddtrace/all/ddtrace.rbi
#
# ddtrace-1.0.0.beta1

module Datadog
end
module Datadog::Transport
end
module Datadog::Transport::IO
  def default(options = nil); end
  def new(out, encoder); end
  def self.default(options = nil); end
  def self.new(out, encoder); end
end
module Datadog::AppSec
  extend Datadog::AppSec::Configuration::ClassMethods
  include Datadog::AppSec::Configuration
end
module Datadog::AppSec::Contrib
end
module Datadog::AppSec::Contrib::Rack
end
module Datadog::AppSec::Contrib::Rack::Request
end
class Datadog::Core::Configuration::Settings
  include Datadog::AppSec::Extensions::Settings
end

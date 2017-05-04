# frozen_string_literal: true

# Copyright 2016-2017 New Context Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "kitchen"

::Kitchen::Config::Parallelism = lambda do |plugin_class:|
  plugin_class.required_config :parallelism do |attribute, value, plugin|
    ::Kitchen::Config::ProcessSchema.call(
      attribute: attribute, plugin: plugin, schema: ::Dry::Validation.Schema do required(:value).filled :int? end,
      value: value
    )
  end
  plugin_class.default_config :parallelism, 10
end

require "dry-validation"
require "kitchen/config/process_schema"

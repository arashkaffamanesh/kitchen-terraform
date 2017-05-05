# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
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

require "kitchen/driver/terraform/verify_client_version"

::RSpec.describe ::Kitchen::Driver::Terraform::VerifyClientVersion do
  describe ".call" do
    let :when_deprecated do instance_double ::Proc end

    let :when_invalid do instance_double ::Proc end

    after do described_class.call version: version, when_deprecated: when_deprecated, when_invalid: when_invalid end

    shared_examples "the version is deprecated" do
      subject do when_deprecated end

      it "calls `when_deprecated` with a warning message" do
        is_expected.to receive(:call).with message: "Support for Terraform version #{version} is deprecated and will " \
                                                      "be dropped in kitchen-terraform version 2.0; upgrade to " \
                                                      "Terraform version 0.9"
      end
    end

    shared_examples "the version is invalid" do
      subject do when_invalid end

      it "calls `when_invalid` with an error message" do
        is_expected.to receive(:call).with message: "Terraform version #{version} is not supported; supported " \
                                                      "versions are 0.7 through 0.9"
      end
    end

    shared_examples "the version is supported" do
      describe "`when_deprecated`" do
        subject do when_deprecated end

        it "is not called" do is_expected.to_not receive :call end
      end

      describe "`when_invalid`" do
        subject do when_invalid end

        it "is not called" do is_expected.to_not receive :call end
      end
    end

    context "when the version is 0.10" do
      let :version do 0.10 end

      it_behaves_like "the version is invalid"
    end

    context "when the version is 0.9" do
      let :version do 0.9 end

      it_behaves_like "the version is supported"
    end

    context "when the version is 0.8" do
      let :version do 0.8 end

      it_behaves_like "the version is deprecated"
    end

    context "when the version is 0.7" do
      let :version do 0.7 end

      it_behaves_like "the version is deprecated"
    end

    context "when the version is 0.6" do
      let :version do 0.6 end

      it_behaves_like "the version is invalid"
    end
  end
end

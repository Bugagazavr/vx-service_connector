require 'spec_helper'

describe Vx::ServiceConnector do

  context "to" do
    subject { described_class.to(name).to_s }

    context ":github" do
      let(:name) { :github }
      it { should be_include("Github") }
    end

    context ":gitlab_v5" do
      let(:name) { :gitlab_v5 }
      it { should be_include("GitlabV5") }
    end
  end

end

require 'spec_helper'

describe Vx::ServiceConnector::GitlabV5 do

  include GitlabV5WebMocks

  let(:endpoint)  { 'http://example.com' }
  let(:token)     { 'token' }
  let(:repo)      { create :repo }
  let(:gitlab)    { described_class.new endpoint, token }

  subject { gitlab }

  it { should be }

  context "(notices)" do
    let(:notices) { gitlab.notices(repo) }

    context "create" do
      subject { notices.create nil, nil, nil, nil }
      it { should be :not_available }
    end
  end

  context "(repos)" do
    subject { gitlab.repos }

    before do
      mock_repos
    end

    it { should have(1).item }

    context "values" do
      subject { gitlab.repos.map(&:values) }
      it { should eq(
        [[9, "example/sqerp", true, "git@example.com:sqerp.git", "http://example.com:80/sqerp", nil]]
      ) }
    end
  end

  context "(deploy_keys)" do
    let(:key_name)    { 'me@example.com' }
    let(:public_key)  { 'public key' }
    let(:deploy_keys) { gitlab.deploy_keys(repo) }

    context "all" do
      subject { deploy_keys.all }
      before { mock_deploy_keys  }
      it { should have(2).items }
    end

    context "create" do
      subject { deploy_keys.create key_name, public_key }
      before { mock_add_deploy_key }
      it { should be }
    end

    context "destroy" do
      subject { deploy_keys.destroy key_name }
      before do
        mock_deploy_keys
        mock_delete_deploy_key
      end

      it { should have(1).item }
    end
  end

  context "(hooks)" do
    let(:url)   { 'url' }
    let(:token) { 'token' }
    let(:hooks) { gitlab.hooks(repo) }

    context "all" do
      subject { hooks.all }
      before { mock_hooks }
      it { should have(1).item }
    end

    context "create" do
      subject { hooks.create url, token }
      before { mock_add_hook }
      it { should be }
    end

    context "destroy" do
      let(:mask) { "http://example.com" }
      subject { hooks.destroy mask }
      before do
        mock_hooks
        mock_remove_hook
      end
      it { should have(1).item }
    end
  end

  context "(files)" do
    let(:sha)  { 'sha' }
    let(:path) { 'path' }

    context "get" do
      subject { gitlab.files(repo).get sha, path }

      context "success" do
        before { mock_get_file  }
        it { should eq 'content' }
      end

      context "not found" do
        before { mock_get_file_not_found }
        it { should be_nil }
      end
    end
  end

end

module Vx
  module ServiceConnector
    module Model

      Repo = Struct.new(
        :id,
        :full_name,
        :is_private,
        :ssh_url,
        :html_url,
        :description
      )

      Payload = Struct.new(
        :ignore?,
        :pull_request?,
        :pull_request_number,
        :branch,
        :branch_label,
        :sha,
        :message,
        :author,
        :author_email,
        :web_url
      ) do
        def to_hash ; to_h end

        class << self
          def from_hash(params)
            payload = Payload.new
            payload.members.each do |m|
              payload[m] = params.key?(m) ? params[m] : params[m.to_s]
            end
            payload
          end
        end
      end

      Commit = Struct.new(
        :sha,
        :message,
        :author,
        :author_email,
        :http_url
      )

      extend self

      def test_payload_attributes(params = {})
        {
          ignore?:              false,
          pull_request?:        false,
          pull_request_number:  nil,
          branch:               'master',
          branch_label:         'master:label',
          sha:                  "HEAD",
          message:              'test commit',
          author:               'User Name',
          author_email:         'me@example.com',
          web_url:              'http://example.com',
        }.merge(params)
      end

      def test_payload(params = {})
        Payload.from_hash(test_payload_attributes params)
      end

      def test_commit
        Commit.new('sha', 'message', 'author', 'author_email', 'http_url')
      end

      def test_repo
        Repo.new(
          1,
          'full/name',
          false,
          'git@example.com',
          'http://example.com',
          'description'
        )
      end

    end

  end
end

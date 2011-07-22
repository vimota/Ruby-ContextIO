require 'oauth'
require 'net/http'

module ContextIO
  VERSION = "2.0"

  class ContextIO::Connection
    def initialize(key='', secret='', server='https://api-preview.context.io')
      @consumer = OAuth::Consumer.new(key, secret, {:site => server, :sheme => :header})
      @token    = OAuth::AccessToken.new @consumer
    end

    def discovery(options)
      get 'discovery', {:source => 'imap'}.merge(options)
    end

    def list_oauth_providers
      get 'oauth_providers'
    end

    def get_oauth_provider(options)
      if ! options.has_key?(:consumer_key) then
        raise ArgumentError, "missing required argument consumer_key", caller
      end
      get "oauth_providers/#{options[:consumer_key]}"
    end

    def delete_oauth_provider(options)
      if ! options.has_key?(:consumer_key) then
        raise ArgumentError, "missing required argument consumer_key", caller
      end
      delete "oauth_providers/#{options[:consumer_key]}"
    end

    def list_contacts(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/contacts", options
    end

    def get_contact(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      get "accounts/#{options[:account]}/contacts/#{options[:email]}"
    end

    def list_contact_files(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/files", options
    end

    def list_contact_messages(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/messages", options
    end

    def list_contact_threads(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/threads", options
    end

    def list_files(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/files", options
    end

    def get_file(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      get "accounts/#{options[:account]}/files/#{options[:file_id]}"
    end

    def get_file_changes(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/changes", options
    end

    def list_file_revisions(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/revisions", options
    end

    def list_file_related(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/related", options
    end

    def list_messages(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/messages", options
    end

    def list_threads(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/threads", options
    end

    def get_account(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}"
    end

    def list_account_email_addresses(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/email_addresses"
    end

    def list_accounts(options)
      get "accounts", options
    end

    def list_sources(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/sources"
    end

    def get_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:label]}"
    end

    def delete_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      delete "accounts/#{options[:account]}/sources/#{options[:label]}"
    end

    def list_source_folders(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:label]}/folders"
    end

    def list_webhooks(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/webhooks"
    end

    def get_webhook(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:webhook_id) then
        raise ArgumentError, "missing required argument webhook_id", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:webhook_id]}"
    end

    def delete_webhook(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:webhook_id) then
        raise ArgumentError, "missing required argument webhook_id", caller
      end
      delete "accounts/#{options[:account]}/sources/#{options[:webhook_id]}"
    end

#    def download_file(options)
#      @token.get "/#{ContextIO::VERSION}/downloadfile?#{parametrize options}"
#    end

    private

    def url(*args)
      if args.length == 1
        "/#{ContextIO::VERSION}/#{args[0]}"
      else
        "/#{ContextIO::VERSION}/#{args.shift.to_s}?#{parametrize args.last}"
      end
    end

    def get(*args)
      @token.get(url(*args), "Accept" => "application/json").body
    end

    def delete(*args)
      @token.delete(url(*args), "Accept" => "application/json").body
    end

    def parametrize(options)
      URI.escape(options.collect do |k,v|
        v = v.to_i if k == :since
        v = v.join(',') if v.instance_of?(Array)
        k = k.to_s.gsub('_', '')
        "#{k}=#{v}"
      end.join('&'))
    end
  end
end

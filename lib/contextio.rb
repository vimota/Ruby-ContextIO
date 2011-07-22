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
      get "oauth_providers/#{options[:consumer_key]}"
    end

    def list_contacts(options)
      get "accounts/#{options[:account]}/contacts", options
    end

    def get_contact(options)
      get "accounts/#{options[:account]}/contacts/#{options[:email]}"
    end

    def list_contact_files(options)
      get "accounts/#{options[:account]}/contacts/#{options[:email]}/files", options
    end

    def list_contact_messages(options)
      get "accounts/#{options[:account]}/contacts/#{options[:email]}/messages", options
    end

    def list_contact_threads(options)
      get "accounts/#{options[:account]}/contacts/#{options[:email]}/threads", options
    end

    def list_files(options)
      get "accounts/#{options[:account]}/files", options
    end

    def get_file(options)
      get "accounts/#{options[:account]}/files/#{options[:file_id]}"
    end

    def get_file_changes(options)
      get "accounts/#{options[:account]}/files/#{options[:file_id]}/changes", options
    end

    def list_file_revisions(options)
      get "accounts/#{options[:account]}/files/#{options[:file_id]}/revisions", options
    end

    def list_file_related(options)
      get "accounts/#{options[:account]}/files/#{options[:file_id]}/related", options
    end

    def list_messages(options)
      get "accounts/#{options[:account]}/messages", options
    end

    def list_threads(options)
      get "accounts/#{options[:account]}/threads", options
    end

    def get_account(options)
      get "accounts/#{options[:account]}"
    end

    def list_account_email_addresses(options)
      get "accounts/#{options[:account]}/email_addresses"
    end

    def list_accounts(options)
      get "accounts", options
    end

    def list_sources(options)
      get "accounts/#{options[:account]}/sources"
    end

    def get_source(options)
      get "accounts/#{options[:account]}/sources/#{options[:source]}"
    end

    def list_source_folders(options)
      get "accounts/#{options[:account]}/sources/#{options[:source]}/folders"
    end

    def list_webhooks(options)
      get "accounts/#{options[:account]}/webhooks"
    end

    def get_webhook(options)
      get "accounts/#{options[:account]}/sources/#{options[:webhook_id]}"
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
      puts url(*args)
      @token.get(url(*args), "Accept" => "application/json").body
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

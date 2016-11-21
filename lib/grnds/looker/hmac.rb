require "grnds/looker/hmac/version"
require 'cgi'
require 'securerandom'
require 'base64'
require 'json'
require 'openssl'

module Grnds
  module Looker
    module Hmac
      class SignedUrlGenerator

        def initialize(config)
          ENV['LOOKER_EMBED_SECRET'] || raise('no LOOKER_EMBED_SECRET provided')
          @config = config
        end

        def getUrl()

          secret = ENV['LOOKER_EMBED_SECRET']

          logger.debug("secret #{secret}")
          logger.debug("config #{@config}")
          json_external_user_id = @config[:external_user_id].to_json
          json_first_name = @config[:first_name].to_json
          json_last_name = @config[:last_name].to_json
          json_permissions = @config[:permissions].to_json
          json_models = @config[:models].to_json
          json_access_filters = @config[:filters].to_json

          path = @config[:path_root] + CGI.escape(@config[:embed_path])

          json_session_length = (@config[:session_length] || 86400).to_json
          json_force_logout_login = true.to_json

          json_current_time = Time.now.to_i.to_json
          json_nonce = SecureRandom.hex(16).to_json

          string_to_sign = ''
          string_to_sign += @config[:host] + "\n"
          string_to_sign += path + "\n"
          string_to_sign += json_nonce + "\n"
          string_to_sign += json_current_time + "\n"
          string_to_sign += json_session_length + "\n"
          string_to_sign += json_external_user_id + "\n"
          string_to_sign += json_permissions + "\n"
          string_to_sign += json_models + "\n"
          string_to_sign += json_access_filters

          signature = Base64.encode64(
              OpenSSL::HMAC.digest(
                  OpenSSL::Digest.new('sha1'),
                  secret,
                  string_to_sign.force_encoding('utf-8'))).strip

          query_params = {
              nonce: json_nonce,
              time: json_current_time,
              session_length: json_session_length,
              external_user_id: json_external_user_id,
              permissions: json_permissions,
              models: json_models,
              access_filters: json_access_filters,
              first_name: json_first_name,
              last_name: json_last_name,
              force_logout_login: json_force_logout_login,
              signature: signature
          }

          query_items = []
          query_params.each_pair do |k,v|
            query_items << k.to_s + "=" + CGI.escape(v)
          end

          query_string = query_items.join('&')
          logger.debug("query_string #{query_string}")
          logger.debug("query https://#{@config[:host]}#{path}?#{query_string}")
          "https://" + @config[:host] + path + '?' + query_string + "\n"
        end
      end
    end
  end
end

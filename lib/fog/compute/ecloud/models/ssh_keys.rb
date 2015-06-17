require File.expand_path("../ssh_key", __FILE__)

module Fog
  module Compute
    class Ecloud
      class SshKeys < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::SshKey

        def all
          data = service.get_ssh_keys(href).body[:SshKey]
          load(data)
        end

        def get(uri)
          if data = service.get_ssh_key(uri).body
            new(data)
          end
        rescue Excon::Errors::NotFound
          nil
        end

        def create(options = {})
          # Make sure we only pass what we should
          new_options           = {}
          new_options[:name]    = options[:name] unless options[:name].nil?
          new_options[:default] = options[:default] || false
          new_options[:uri]     = href + "/action/createSshKey"

          data = service.ssh_key_create(new_options)
          object = service.ssh_keys.new(data)
          object
        end

        def environment_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end

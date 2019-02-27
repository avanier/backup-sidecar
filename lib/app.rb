# frozen_string_literal: true

require_relative('version')
require('thor')

# Ax
# Top level container
# @since 0.1.0
module Ax
    # BackupSidecar
    # A Ruby operated program to be used as a sidecar in Kubernetes pods to backup
    # ephemeral or persistent data.
    # @since 0.1.0
    module BackupSidecar
      # App
      # The top of stack abstraction for this application.
      # Read through the code to check the sequence of events.
      # @since 0.1.0
      class App < Thor
        include Ax::BackupSidecar::Version

        package_name 'backup-sidecar'

        map %w[--version -v] => :print_version

        # Displays the gem's version when invoked in the CLI.
        # @since 0.1.0
        desc '--version, -v', 'print the version'
        def print_version
          puts GEM_VERSION
        end

        method_option :config_file,
          aliases: '-C',
          desc: 'Points to the backup config file to use',
          required: true,
          type: :string

        desc 'backup', 'Start backup according to configuration file'
        # Performs a backup according to sources and targets defined in the config
        # file.
        # @since 0.1.0
        def backup
        end
    end
  end
end

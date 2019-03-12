# frozen_string_literal: true

require_relative('version')
require_relative('logging')
require_relative('backup')
require('erb')
require('fileutils')
require('rufus-scheduler')
require('tempfile')
require('thor')
require('yaml')

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
      include Ax::BackupSidecar::Logging
      include Ax::BackupSidecar::Backup

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
        # load yaml file
        c = YAML.load_file(options[:config_file])
        s = Rufus::Scheduler.new

        # fetch, validate and parse keylist if necessary
        # keylists should be refetched and revalidated every backup job instance
        if c.dig('recipients', 'keylists')
          Log.warn(
            'Keylists retreival and parsing is not implemented',
            keylists: c['recipients']['keylists']
          )
        end
        Log.debug('Dumping config', c)

        Log.info("Scheduler will trigger on cron-like schedule of [ #{c['schedule']} ]")

        s.in('0s') do
          Log.debug('This is starting now')
          perform_backup(c)
        end if ENV['START_NOW']

        s.cron(c['schedule']) do
          # Log.debug('Schedule triggerred', schedule: c['schedule'])
          # perform_backup(c)
        end

        s.join
      end
    end
  end
end

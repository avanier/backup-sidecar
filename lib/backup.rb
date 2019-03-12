# frozen_string_literal: true
require('mixlib/shellout')

module Ax
  module BackupSidecar
    module Backup
      require_relative('logging')
      include Ax::BackupSidecar::Logging

      module_function

      def perform_backup(c)
        Log.debug('Reached backup module')

        begin
          workspace = Dir.mktmpdir('backup-sidecar')

          template_path = File.join(
            File.dirname(__FILE__),
            'assets/template.erb'
          )
          Log.debug('Reading template from', path: template_path)

          template_source = File.read(template_path)
          Log.trace('Dumping template source')
          Log.trace(template_source)
  
          template = ERB.new(template_source, nil, '-').result(binding)
          Log.debug('Dumping rendered template')
          Log.debug(template)

          backup_instance = File.join(workspace, Time.now.utc.iso8601 + '.rb')
          File.open(backup_instance, 'w') do |file|
            file.write(template)
          end

          backup_cmd_string = "backup perform --trigger backup_sidecar --config-file #{backup_instance} --check"
          backup_cmd = Mixlib::ShellOut.new(backup_cmd_string,
            :env => ENV,
            :cwd => '/'
            )
          backup_cmd.run_command

          Log.fatal('Fatal error encountered',
            stderr: backup_cmd.stderr,
            stdout: backup_cmd.stdout
          ) if backup_cmd.error?

          # etc.
          # call the gem with mixlib shellout :facepalm:
            # we'll have to see about making sure the env's passed to it ...
        ensure
          FileUtils.rm_rf(workspace)
          exit(0)
        end
      end
    end
  end
end

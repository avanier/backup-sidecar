require_relative('lib/version')
include Ax::BackupSidecar::Version

Gem::Specification.new do |s|
  s.name = 'backup-sidecar'
  s.authors = [
    'Alexis Vanier'
  ]
  s.version = GEM_VERSION
  s.date = '2019-02-25'
  s.summary = 'Backs-up, tars, encrypts, ships out stuff from a simple config'
  s.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md Gemfile]
  s.require_paths = ['lib']
  s.executables = ['backup-sidecar']
  s.licenses = ['MIT']
  s.homepage = 'https://www.github.com/avanier/backup-sidecar'
  s.add_dependency('ougai', '~> 1.7')
  s.add_dependency('thor', '~> 0.20.0')
  s.add_dependency('awesome_print')
end

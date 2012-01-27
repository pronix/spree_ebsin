Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ebsin'
  s.version     = '1.0.0'
  s.summary     = 'Add gem summary here'
  s.description = 'Ebs gateway for Spree'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Prashanth HN'
  s.email             = 'prashanth@prashanth.net'
  s.homepage          = 'http://www.prashanth.net'
  #s.rubyforge_project = 'actionmailer'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.40.2')
end
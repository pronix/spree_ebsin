Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ebsin'
  s.version     = '1.1.5'
  s.summary     = 'Add gem summary here'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'
  s.author            = ['Dmitry Vasilets','Damir Sharipov','Maxim Pechnikov']
  s.email             = ['parallel588@gmail.com','pronix.service@gmail.com','dammer2k@gmail.com']
  s.homepage          = 'http://vasilec.blogspot.de/'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.40.2')
end

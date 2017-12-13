# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name             = "NAME"
  spec.version          = 0.0.1
  spec.authors          = ['Rudi Strydom']
  spec.email            = ['iam@thatguy.co.za']
  spec.summary          = %q{Short summary of your project}
  spec.description      = %q{Longer description of your project}
  spec.homepage         = "https://github.com/drpain/App"
  spec.license          = "MIT"

  spec.files            = Dir['{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  spec.executables      = ['app.rb']
  spec.test_files       = ['spec/app_spec.rb']
  spec.require_paths    = ['lib']
end
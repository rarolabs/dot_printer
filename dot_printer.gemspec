$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dot_printer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dot_printer"
  s.version     = DotPrinter::VERSION
  s.authors     = ["Rodrigo Sol"]
  s.email       = ["rodrigo@rarolabs.com.br"]
  s.homepage    = "http://www.rarolabs.com.br"
  s.summary     = "Dot matrix report generator for rails"
  s.description = "This gem provides a DSL for reporting in dot matrix printers"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
end

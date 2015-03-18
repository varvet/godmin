$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "godmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "godmin"
  gem.version     = Godmin::VERSION
  gem.authors     = ["Jens Ljungblad", "Linus Pettersson", "Varvet"]
  gem.email       = ["info@varvet.se"]
  gem.homepage    = "https://github.com/varvet/godmin"
  gem.summary     = "Godmin is an admin framework for Rails 4+"
  gem.description = "Godmin is an admin framework for Rails 4+"
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "bcrypt", "~> 3.1.7"
  gem.add_dependency "bootstrap-sass", "~> 3.3.3"
  gem.add_dependency "bootstrap_form", "~> 2.2.0"
  gem.add_dependency "coffee-rails", [">= 4.0", "< 4.2"]
  gem.add_dependency "momentjs-rails", ">= 2.8.1"
  gem.add_dependency "rails", "~> 4.0"
  gem.add_dependency "sass-rails", ">= 4.0"
  gem.add_dependency "selectize-rails", "~> 0.11.2"

  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "minitest-reporters"
  gem.add_development_dependency "pry"
end

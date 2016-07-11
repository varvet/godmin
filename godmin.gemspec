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
  gem.description = "Godmin is an admin framework for Rails 4+. Use it to build dedicated admin sections for your apps, or stand alone admin apps such as internal tools."
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "bcrypt", "~> 3.1"
  gem.add_dependency "bootstrap_form", "~> 2.4"
  gem.add_dependency "bootstrap-sass", "~> 3.3"
  gem.add_dependency "coffee-rails", [">= 4.0", "< 6.0"]
  gem.add_dependency "csv_builder", "~> 2.1"
  gem.add_dependency "jquery-rails", [">= 3.0", "< 5.0"]
  gem.add_dependency "momentjs-rails", "~> 2.8"
  gem.add_dependency "rails", [">= 4.0", "< 6.0"]
  gem.add_dependency "sass-rails", [">= 4.0", "< 6.0"]
  gem.add_dependency "selectize-rails", "~> 0.12"

  gem.add_development_dependency "appraisal", "~> 2.1"
  gem.add_development_dependency "capybara", "~> 2.4"
  gem.add_development_dependency "m", "~> 1.3"
  gem.add_development_dependency "minitest-reporters", "~> 1.0"
  gem.add_development_dependency "minitest", "~> 5.5"
  gem.add_development_dependency "poltergeist", "~> 1.7"
  gem.add_development_dependency "pry", "~> 0.10"
  gem.add_development_dependency "sqlite3", "~> 1.3"
end

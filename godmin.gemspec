$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "godmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "godmin"
  s.version     = Godmin::VERSION
  s.authors     = ["Varvet"]
  s.email       = ["hej@varvet.se"]
  s.homepage    = "http://varvet.se"
  s.summary     = "Varvets admin"
  s.description = "Varvets admin"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", [">= 4.0", "< 4.2"]
  s.add_dependency "sass-rails", [">= 4.0", "< 4.2"]
  s.add_dependency "coffee-rails", [">= 4.0", "< 4.2"]
  s.add_dependency "bcrypt", "~> 3.1.7"
  s.add_dependency "bootstrap-sass", "~> 3.1.1.0"
  s.add_dependency "kaminari", "~> 0.15.1"
  s.add_dependency "select2-rails", "~> 3.5.7"
  s.add_dependency "simple_form", "~> 3.0.0"

  s.add_development_dependency "sqlite3"
end

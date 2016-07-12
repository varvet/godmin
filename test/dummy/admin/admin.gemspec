$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin"
  s.version     = Admin::VERSION
  s.authors     = ["admin"]
  s.email       = ["admin@example.com"]
  s.summary     = "admin"

  s.files = Dir["{app,config,db,lib}/**/*"]
end

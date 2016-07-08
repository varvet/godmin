begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "Godmin"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

Bundler::GemHelper.install_tasks

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
  t.verbose = false
end

task default: :test

namespace :sandbox do
  desc "Generate the Sandbox app then push it to GitHub which deploys it to Heroku"
  task :deploy do
    message = "Generated from: https://github.com/varvet/godmin/commit/#{`git rev-parse HEAD`.strip}"
    template_path = File.expand_path("../template.rb", __FILE__)
    Bundler.with_clean_env do
      Dir.mktmpdir do |dir|
        Dir.chdir(dir)
        system("git clone git@github.com:varvet/godmin-sandbox.git")
        if $CHILD_STATUS.success?
          Dir.chdir("godmin-sandbox")
          system("rm -rf *")
          system("rails new . -d postgresql -m #{template_path} --without-engine")
          if $CHILD_STATUS.success?
            system("git add --all")
            system("git commit -m '#{message}'")
            system("git push origin master")
          end
        end
      end
    end
  end

  desc "Empty and reseed the database on Heroku"
  task :reseed do
    app = "godmin-sandbox"
    Bundler.with_clean_env do
      system("heroku run rake sandbox:reseed --app #{app}")
    end
  end
end

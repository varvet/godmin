begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Godmin'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'



Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

namespace :deploy do
  desc "Update the sandbox app on Github"
  task :update do
    sandbox = "godmin-sandbox"
    sandbox_dir = "/tmp/#{sandbox}-#{Time.now.strftime("%Y%m%d")}"
    puts "Working in #{sandbox_dir}"
    template_file = File.expand_path("../template.rb", __FILE__)
    system("rm -rf #{sandbox_dir}")
    system("mkdir #{sandbox_dir}")
    system("cd #{sandbox_dir} && git clone git@github.com:varvet/#{sandbox}.git")
    system("cd #{sandbox_dir}/#{sandbox} && rm -rf *")
    system("cd #{sandbox_dir} && rails new #{sandbox} -m #{template_file} --without-engine")
    system("cd #{sandbox_dir}/#{sandbox} && bundle")
    system("cd #{sandbox_dir}/#{sandbox} && git status")
    # system("cd #{sandbox_dir}/#{sandbox} && git add .")
    # system("cd #{sandbox_dir}/#{sandbox} && git commit -m 'Initial commit'")
    # system("cd #{sandbox_dir}/#{sandbox} && git push origin master")
  end

  desc "Empty and reseed database on Heroku"
  task :reseed do
    app = "godmin-sandbox"
    Bundler.with_clean_env do
      system("heroku pg:reset DATABASE_URL --confirm #{app}")
      system("heroku run rake db:migrate --app #{app}")
      system("heroku run rake db:seed --app #{app}")
    end
  end

end

task default: :test

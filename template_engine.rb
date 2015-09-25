require "active_support/all"

run_ruby_script("bin/rails plugin new admin --mountable")

gsub_file "admin/admin.gemspec", "TODO: ", ""
gsub_file "admin/admin.gemspec", "TODO", ""

inject_into_file "admin/admin.gemspec", before: /^end/ do
  <<-END.strip_heredoc.indent(2)
    s.add_dependency "godmin", "> 0.12"
  END
end

gem "admin", path: "admin"

after_bundle do
  generate(:model, "article title:string body:text published:boolean published_at:datetime")
  run_ruby_script("admin/bin/rails g godmin:install")
  run_ruby_script("admin/bin/rails g godmin:resource article")
end

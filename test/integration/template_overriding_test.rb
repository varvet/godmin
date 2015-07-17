require "test_helper"

class TemplateOverridingTest < ActionDispatch::IntegrationTest
  # def test_no_override_template
  #   visit articles_path
  #   assert page.has_content? "Article"
  # end

  def test_override_template
    # with_template "articles/index.html.erb", "foobar" do
      visit articles_path
      save_and_open_page
      # require "pry"
      # binding.pry
      assert page.has_content? "foobar"
    # end
  end

  def with_template(path, content)
    path = File.expand_path("../../dummy/app/views/#{path}", __FILE__)
    # require "pry"
    # binding.pry
    File.open(path, "w") { |file| file.write content }
    yield

    # Tempfile.create(name, path) do |f|
    #   f.write content
    #   yield
    # end

  end
end

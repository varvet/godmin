require "test_helper"

class TemplateOverridingTest < ActionDispatch::IntegrationTest
  def test_default_template
    visit articles_path
    assert page.has_content? "Create Article"
  end

  def test_override_template
    add_template "articles/index.html.erb", "foo"
    visit articles_path
    assert page.has_content? "foo"
  end

  def test_override_resource_template
    add_template "resource/index.html.erb", "foo"
    visit articles_path
    assert page.has_content? "foo"
  end

  def test_override_template_and_resource_template
    add_template "articles/index.html.erb", "foo"
    add_template "resource/index.html.erb", "bar"
    visit articles_path
    assert page.has_content? "foo"
  end
end

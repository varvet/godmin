require "test_helper"

class TemplateOverridingTest < ActionDispatch::IntegrationTest
  def test_default_template
    visit articles_path
    assert page.has_content? "Create Article"
  end

  def test_override_template
    add_template "app/views/articles/index.html.erb", "foo"
    visit articles_path
    assert page.has_content? "foo"
  end

  def test_override_resource_template
    add_template "app/views/resource/index.html.erb", "foo"
    visit articles_path
    assert page.has_content? "foo"
  end

  def test_override_template_and_resource_template
    add_template "app/views/articles/index.html.erb", "foo"
    add_template "app/views/resource/index.html.erb", "bar"
    visit articles_path
    assert page.has_content? "foo"
  end

  def test_default_template_in_engine
    visit admin.articles_path
    assert page.has_content? "Create Article"
  end

  def test_override_template_in_engine
    add_template "admin/app/views/admin/articles/index.html.erb", "foo"
    visit admin.articles_path
    assert page.has_content? "foo"
  end

  def test_override_resource_template_in_engine
    add_template "admin/app/views/admin/resource/index.html.erb", "foo"
    visit admin.articles_path
    assert page.has_content? "foo"
  end

  def test_override_template_and_resource_template_in_engine
    add_template "admin/app/views/admin/articles/index.html.erb", "foo"
    add_template "admin/app/views/admin/resource/index.html.erb", "bar"
    visit admin.articles_path
    assert page.has_content? "foo"
  end
end

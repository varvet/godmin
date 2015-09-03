require "test_helper"

class PartialOverridingTest < ActionDispatch::IntegrationTest
  def test_default_partial
    visit new_article_path
    assert page.has_content? "Title"
  end

  def test_override_partial
    add_template "app/views/articles/_form.html.erb", "foo"
    visit new_article_path
    assert page.has_content? "foo"
  end

  def test_override_resource_partial
    add_template "app/views/resource/_form.html.erb", "foo"
    visit new_article_path
    assert page.has_content? "foo"
  end

  def test_override_partial_and_resource_partial
    add_template "app/views/articles/_form.html.erb", "foo"
    add_template "app/views/resource/_form.html.erb", "bar"
    visit new_article_path
    assert page.has_content? "foo"
  end

  def test_default_partial_in_engine
    visit admin.new_article_path
    assert page.has_content? "Title"
  end

  def test_override_partial_in_engine
    add_template "admin/app/views/admin/articles/_form.html.erb", "foo"
    visit admin.new_article_path
    assert page.has_content? "foo"
  end

  def test_override_resource_partial_in_engine
    add_template "admin/app/views/admin/resource/_form.html.erb", "foo"
    visit admin.new_article_path
    assert page.has_content? "foo"
  end

  def test_override_partial_and_resource_partial_in_engine
    add_template "admin/app/views/admin/articles/_form.html.erb", "foo"
    add_template "admin/app/views/admin/resource/_form.html.erb", "bar"
    visit admin.new_article_path
    assert page.has_content? "foo"
  end
end

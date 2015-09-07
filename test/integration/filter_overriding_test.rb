require "test_helper"

class ColumnOverridingTest < ActionDispatch::IntegrationTest
  def test_default_filter
    visit articles_path
    assert find("#filters").has_content? "Title"
  end

  def test_override_filter
    add_template "app/views/articles/filters/_title.html.erb", "foo"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_resource_filter
    add_template "app/views/resource/filters/_title.html.erb", "foo"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_filter_and_resource_filter
    add_template "app/views/articles/filters/_title.html.erb", "foo"
    add_template "app/views/resource/filters/_title.html.erb", "bar"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_default_filter_in_engine
    visit admin.articles_path
    assert find("#filters").has_content? "Title"
  end

  def test_override_filter_in_engine
    add_template "admin/app/views/admin/articles/filters/_title.html.erb", "foo"
    visit admin.articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_resource_filter_in_engine
    add_template "admin/app/views/admin/resource/filters/_title.html.erb", "foo"
    visit admin.articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_filter_and_resource_filter_in_engine
    add_template "admin/app/views/admin/articles/filters/_title.html.erb", "foo"
    add_template "admin/app/views/admin/resource/filters/_title.html.erb", "bar"
    visit admin.articles_path
    assert find("#filters").has_content? "foo"
  end
end

require "test_helper"

class ColumnOverridingTest < ActionDispatch::IntegrationTest
  def test_default_column
    Article.create! title: "foo"
    visit articles_path
    assert find("#table").has_content? "foo"
  end

  def test_override_column
    Article.create! title: "foo"
    add_template "app/views/articles/columns/_title.html.erb", "bar"
    visit articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_resource_column
    Article.create! title: "foo"
    add_template "app/views/resource/columns/_title.html.erb", "bar"
    visit articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_column_and_resource_column
    Article.create! title: "foo"
    add_template "app/views/articles/columns/_title.html.erb", "bar"
    add_template "app/views/resource/columns/_title.html.erb", "baz"
    visit articles_path
    assert find("#table").has_content? "bar"
  end

  def test_default_column_in_engine
    Article.create! title: "foo"
    visit admin.articles_path
    assert find("#table").has_content? "foo"
  end

  def test_override_column_in_engine
    Article.create! title: "foo"
    add_template "admin/app/views/admin/articles/columns/_title.html.erb", "bar"
    visit admin.articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_resource_column_in_engine
    Article.create! title: "foo"
    add_template "admin/app/views/admin/resource/columns/_title.html.erb", "bar"
    visit admin.articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_column_and_resource_column_in_engine
    Article.create! title: "foo"
    add_template "admin/app/views/admin/articles/columns/_title.html.erb", "bar"
    add_template "admin/app/views/admin/resource/columns/_title.html.erb", "baz"
    visit admin.articles_path
    assert find("#table").has_content? "bar"
  end
end

require "test_helper"

class ColumnOverridingTest < ActionDispatch::IntegrationTest
  def test_default_column
    Article.create! title: "foo"
    visit articles_path
    assert find("#table").has_content? "foo"
  end

  def test_override_column
    Article.create! title: "foo"
    add_template "articles/columns/_title.html.erb", "bar"
    visit articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_resource_column
    Article.create! title: "foo"
    add_template "resource/columns/_title.html.erb", "bar"
    visit articles_path
    assert find("#table").has_content? "bar"
  end

  def test_override_column_and_resource_column
    Article.create! title: "foo"
    add_template "articles/columns/_title.html.erb", "bar"
    add_template "resource/columns/_title.html.erb", "baz"
    visit articles_path
    assert find("#table").has_content? "bar"
  end
end

require "test_helper"

class ColumnOverridingTest < ActionDispatch::IntegrationTest
  def test_default_filter
    visit articles_path
    assert find("#filters").has_content? "Title"
  end

  def test_override_filter
    add_template "articles/filters/_title.html.erb", "foo"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_resource_filter
    add_template "resource/filters/_title.html.erb", "foo"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end

  def test_override_filter_and_resource_filter
    add_template "articles/filters/_title.html.erb", "foo"
    add_template "resource/filters/_title.html.erb", "bar"
    visit articles_path
    assert find("#filters").has_content? "foo"
  end
end

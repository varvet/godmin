require "test_helper"

class PartialOverridingTest < ActionDispatch::IntegrationTest
  def test_default_partial
    visit new_article_path
    assert page.has_content? "Title"
  end

  def test_override_partial
    add_template "articles/_form.html.erb", "foo"
    visit new_article_path
    assert page.has_content? "foo"
  end

  # def test_override_resource_partial
  #   with_template "resource/_form.html.erb", "foo" do
  #     visit new_article_path
  #     assert page.has_content? "foo"
  #   end
  # end
  #
  # def test_override_partial_and_resource_partial
  #   with_template "articles/_form.html.erb", "foo" do
  #     with_template "resource/_form.html.erb", "bar" do
  #       visit new_article_path
  #       assert page.has_content? "foo"
  #     end
  #   end
  # end
  #
  # def test_default_column
  #   Article.create! title: "foo"
  #   visit articles_path
  #   assert page.has_content? "foo"
  # end
  #
  # def test_override_column
  #   Article.create! title: "foo"
  #   with_template "articles/columns/_title.html.erb", "bar" do
  #     visit articles_path
  #     assert page.has_content? "bar"
  #   end
  # end
  #
  # def test_override_resource_column
  #   Article.create! title: "foo"
  #   with_template "resource/columns/_title.html.erb", "bar" do
  #     visit articles_path
  #     assert page.has_content? "bar"
  #   end
  # end
  #
  # def test_override_column_and_resource_column
  #   Article.create! title: "foo"
  #   with_template "articles/columns/_title.html.erb", "foo" do
  #     with_template "resource/columns/_title.html.erb", "bar" do
  #       visit articles_path
  #       assert page.has_content? "foo"
  #     end
  #   end
  # end
end

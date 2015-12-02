require "test_helper"

class SignInTest < ActionDispatch::IntegrationTest
  def test_list_resources
    Article.create! title: "foo"
    Article.create! title: "bar"

    visit articles_path

    assert page.has_content? "foo"
    assert page.has_content? "bar"
  end

  def test_show_resource
    article = Article.create! title: "foo", body: "bar"

    visit articles_path
    within "[data-resource-id='#{article.id}']" do
      click_link "Show"
    end

    assert page.has_content? "Title foo"
    assert page.has_content? "Body bar"
  end

  def test_create_resource
    visit articles_path
    click_link "Create Article"
    fill_in "Title", with: "foo"
    fill_in "Body", with: "bar"
    click_button "Create Article"

    assert_equal article_path(Article.last), current_path
    assert page.has_content? "Title foo"
    assert page.has_content? "Body bar"
  end

  def test_update_resource
    article = Article.create! title: "foo", body: "bar"

    visit articles_path
    within "[data-resource-id='#{article.id}']" do
      click_link "Edit"
    end
    fill_in "Title", with: "baz"
    click_button "Update Article"

    assert_equal article_path(article), current_path
    assert page.has_content? "Title baz"
    assert page.has_content? "Body bar"
  end

  def test_destroy_resource
    article_1 = Article.create! title: "foo"
    article_2 = Article.create! title: "bar"

    visit articles_path
    within "[data-resource-id='#{article_1.id}']" do
      click_link "Destroy"
    end

    assert_equal articles_path, current_path
    assert page.has_no_content? "foo"
    assert page.has_content? "bar"
  end
end

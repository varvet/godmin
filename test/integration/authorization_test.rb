require "test_helper"

class AuthorizationTest < ActionDispatch::IntegrationTest
  def test_can_index?
    visit authorized_articles_path
    assert_equal 200, page.status_code
  end

  def test_can_show?
    article = Article.create! title: "foo"

    visit authorized_articles_path
    within "[data-resource-id='#{article.id}']" do
      click_link "Show"
    end

    assert_equal article_path(article), current_path
    assert_equal 200, page.status_code
  end

  def test_cannot_destroy?
    article = Article.create! title: "foo"

    visit authorized_articles_path
    within "[data-resource-id='#{article.id}']" do
      assert page.has_no_content? "Destroy"
    end

    page.driver.delete authorized_article_path(article)
    assert_equal 403, page.status_code
  end

  def test_cannot_index_in_engine?
    visit admin.authorized_articles_path
    assert_equal 403, page.status_code
  end

  def test_uses_engine_policy_in_engine?
    visit admin.new_authorized_article_path

    assert_equal 200, page.status_code

    assert page.has_content?("Can't index"), "when used in an engine, the `policy` method is using the policy from the main app, not the engine"
  end
end

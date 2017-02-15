require "test_helper"

class ScopesTest < ActionDispatch::IntegrationTest
  def test_scopes
    Article.create! title: "foo"
    Article.create! title: "bar"
    Article.create! title: "baz", published: true

    visit articles_path(scope: :unpublished)

    assert page.has_content? "foo"
    assert page.has_content? "bar"
    assert page.has_no_content? "baz"

    within "#scopes" do
      click_link "Published"
    end

    assert page.has_no_content? "foo"
    assert page.has_no_content? "bar"
    assert page.has_content? "baz"
  end
end

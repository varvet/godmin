require "test_helper"

class FiltersTest < ActionDispatch::IntegrationTest
  def test_filter
    Article.create! title: "foo"
    Article.create! title: "bar"

    visit articles_path

    fill_in "Title", with: "foo"
    click_button "Filter"
    assert page.has_content? "foo"
    assert_not page.has_content? "bar"

    click_link "Clear filter"
    assert page.has_content? "foo"
    assert page.has_content? "bar"
  end
end

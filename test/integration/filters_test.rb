require "test_helper"

class FiltersTest < ActionDispatch::IntegrationTest
  def test_filter
    Article.create! title: "foo"
    Article.create! title: "bar"

    visit articles_path

    fill_in "Title", with: "foo"
    click_button "Filter"
    assert_equal 200, page.status_code
    assert page.has_content? "foo"
    assert page.has_no_content? "bar"

    click_link "Clear filter"
    assert_equal 200, page.status_code
    assert page.has_content? "foo"
    assert page.has_content? "bar"
  end

  def test_select_filter
    Article.create! title: "foo", published: true
    Article.create! title: "bar"

    visit articles_path

    within "#filters" do
      find("select").select("Published")
    end
    click_button "Filter"
    assert_equal 200, page.status_code
    assert page.has_content? "foo"
    assert page.has_no_content? "bar"
  end
end

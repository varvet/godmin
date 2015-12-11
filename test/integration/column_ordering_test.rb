require "test_helper"

class ColumnOrderingTest < ActionDispatch::IntegrationTest
  def test_default_order_links
    visit articles_path
    link = find("#table th.column-created_at a")
    assert_equal "/articles?order=created_at_desc", link[:href]
  end

  def test_order_flipped
    visit articles_path
    link_matcher = "#table th.column-created_at a"
    find(link_matcher).click
    link = find(link_matcher)
    assert_equal "/articles?order=created_at_asc", link[:href]
  end

  def test_order_links_when_order_empty
    visit articles_path(order: "")
    link = find("#table th.column-created_at a")
    assert_equal "/articles?order=created_at_desc", link[:href]
  end

  def test_order_links_when_not_orderable
    visit articles_path
    assert has_selector?("#table th.column-non_orderable_column")
    assert has_no_link?("#table th.column-non_orderable_column a")
  end

  def test_order_links_when_custom_orderable
    visit articles_path
    link = find("#table th.column-admin_user a")
    assert_equal "/articles?order=admin_user_desc", link[:href]
  end
end

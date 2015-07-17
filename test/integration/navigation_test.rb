require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  def test_stuff
    visit "/"
    assert page.has_content? "Welcome"
  end
end

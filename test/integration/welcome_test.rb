require "test_helper"

class WelcomeTest < ActionDispatch::IntegrationTest
  def test_welcome
    visit "/"
    assert page.has_content? "Welcome"
  end
end

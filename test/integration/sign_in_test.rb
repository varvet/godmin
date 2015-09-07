require "test_helper"

class SignInTest < ActionDispatch::IntegrationTest
  def test_sign_in_and_out
    AdminUser.create!(email: "admin@example.com", password: "password")
    visit secret_articles_path
    assert_not_equal secret_articles_path, current_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    visit secret_articles_path
    assert_equal secret_articles_path, current_path
    click_link "Sign out"
    visit secret_articles_path
    assert_not_equal secret_articles_path, current_path
  end
end

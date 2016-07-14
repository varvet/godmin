require "test_helper"

class BatchActionsTest < ActionDispatch::IntegrationTest
  def test_batch_action
    Capybara.current_driver = Capybara.javascript_driver

    Article.create! title: "foo"
    Article.create! title: "bar"

    visit articles_path

    all("[data-behavior~=batch-actions-checkbox]").each(&:click)
    within "#actions" do
      click_link "Destroy"
    end

    assert_equal 200, page.status_code
    assert page.has_no_content? "foo"
    assert page.has_no_content? "bar"

    Capybara.use_default_driver
  end

  def test_batch_action_redirect
    Capybara.current_driver = Capybara.javascript_driver

    Article.create! title: "foo"

    visit articles_path(scope: :unpublished)

    all("[data-behavior~=batch-actions-checkbox]").each(&:click)
    within "#actions" do
      click_link "Publish"
    end

    assert_equal articles_path(scope: :published), current_path_with_params
    assert_equal 200, page.status_code

    Capybara.use_default_driver
  end

  def test_batch_action_scopes
    Capybara.current_driver = Capybara.javascript_driver

    Article.create! title: "foo"

    visit articles_path(scope: :unpublished)

    all("[data-behavior~=batch-actions-checkbox]").each(&:click)
    within "#actions" do
      assert page.has_content? "Publish"
      assert page.has_no_content? "Unpublish"
    end

    Capybara.use_default_driver
  end

  def test_batch_action_scopes_when_no_batch_actions
    Capybara.current_driver = Capybara.javascript_driver

    Article.create! title: "foo"

    visit articles_path(scope: :no_batch_actions)

    assert page.has_no_content?("Select all")
    assert page.has_no_css?("[data-behavior~=batch-actions-checkbox]")

    Capybara.use_default_driver
  end

  private

  def current_path_with_params
    "#{current_uri.path}?#{current_uri.query}"
  end

  def current_uri
    URI.parse(page.current_url)
  end
end

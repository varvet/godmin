require "test_helper"

class BatchActionsTest < ActionDispatch::IntegrationTest
  def test_batch_action
    Capybara.current_driver = :poltergeist

    Article.create! title: "foo"
    Article.create! title: "bar"

    visit articles_path

    all(:css, "[data-behavior~=batch-actions-checkbox]").each do |el|
      el.set(true)
    end
    within "#actions" do
      click_link "Destroy"
    end
    assert_not page.has_content? "foo"
    assert_not page.has_content? "bar"

    Capybara.use_default_driver
  end
end

require "test_helper"

class TemplateOverridingTest < ActionDispatch::IntegrationTest
  def test_default_template
    visit articles_path
    assert page.has_content? "Create Article"
  end

  def test_override_template
    with_template "articles/index.html.erb", "foo" do
      visit articles_path
      assert page.has_content? "foo"
    end
  end

  def test_override_resource_template
    with_template "resource/index.html.erb", "foo" do
      visit articles_path
      assert page.has_content? "foo"
    end
  end

  def test_override_template_and_resource_template
    with_template "articles/index.html.erb", "foo" do
      with_template "resource/index.html.erb", "bar" do
        visit articles_path
        assert page.has_content? "foo"
      end
    end
  end
end

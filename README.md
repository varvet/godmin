# Godmin

[![Gem Version](http://img.shields.io/gem/v/godmin.svg)](https://rubygems.org/gems/godmin)
[![Build Status](https://img.shields.io/travis/varvet/godmin/master.svg)](https://travis-ci.org/varvet/godmin)
[![Code Climate](https://img.shields.io/codeclimate/github/varvet/godmin.svg)](https://codeclimate.com/github/varvet/godmin)

Godmin is an admin framework for Rails 4+.

- [Installation](#installation)
	- [Standalone installation](#standalone-installation)
	- [Engine installation](#engine-installation)
	- [Installation artefacts](#installation-artefacts)
- [Getting started](#getting-started)
- [Controllers](#controllers)
	- [Scopes](#scopes)
	- [Filters](#filters)
	- [Batch actions](#batch-actions)
	- [Resource fetching, building and saving](#resource-fetching-building-and-saving)
	- [Redirecting](#redirecting)
	- [Pagination](#pagination)
- [Views](#views)
  - [Forms](#forms)
- [Authentication](#authentication)
	- [Simple authentication](#simple-authentication)
	- [Shared authentication](#shared-authentication)
- [Authorization](#authorization)
- [Localization](#localization)
- [JavaScript](#javascript)
- [Plugins](#plugins)
- [Contributors](#contributors)
- [License](#license)

## Installation

Godmin supports two common admin scenarios:

1. Standalone installation
2. Engine installation

### Standalone installation
Use for admin-only applications, or for architectures where the admin lives in its own app. E.g. you want to access the admin section at `localhost:3000`.

Add the gem to the application's `Gemfile`:
```ruby
gem "godmin"
```

Bundle then run the install generator:
```sh
$ bundle install
$ bin/rails generate godmin:install
```

Godmin should be up and running at `localhost:3000`.

### Engine installation
Use when the admin is part of the same codebase as the main application. E.g. you want to access the admin section at `localhost:3000/admin`.

Generate a [mountable engine](http://guides.rubyonrails.org/engines.html):
```sh
$ bin/rails plugin new admin --mountable
```

Add the engine to the application's `Gemfile`:
```ruby
gem "admin", path: "admin"
```

Mount the engine in the application's `config/routes.rb`:
```ruby
mount Admin::Engine, at: "admin"
```

Add the gem to the engine's gemspec, `admin/admin.gemspec`:
```ruby
s.add_dependency "godmin", "~> x.x.x"
```

Bundle then run the install generator within the scope of the engine, i.e. note the leading `admin/`:
```sh
$ bundle install
$ admin/bin/rails generate godmin:install
```

Godmin should be up and running at `localhost:3000/admin`

### Installation artefacts

Installing Godmin does a number of things to the Rails application.

A `config/initializers/godmin.rb` is created:
```ruby
Godmin.configure do |config|
  config.namespace = nil
end
```

If Godmin was installed inside an engine, as in the previous section, the namespace is the underscored name of the engine, e.g. `"admin"`.

The `config/routes.rb` file is modified as such:
```ruby
Rails.application.routes.draw do
  godmin do
  end
end
```

Resource routes placed within the `godmin` block are automatically added to the default navigation.

The application controller is modified as such:
```ruby
class ApplicationController < ActionController::Base
  include Godmin::ApplicationController
end
```

Require statements are placed in both `app/assets/javascripts/application.js` and `app/assets/stylesheets/application.css`.

If Godmin was installed inside an engine, a `require "godmin"` statement is placed in `{namespace}/lib/{namespace}.rb`.

And finally, the `app/views/layouts` folder is removed by default, so as not to interfere with the Godmin layouts. It can be added back in case you wish to override the built in layouts.

## Getting started

Godmin deals primarily with resources. A resource is something that can be administered through the Godmin user interface, often a Rails model. Let's say the application has an `Article` model with attributes such as `title`, `body` and `published`. To get going quickly, we can use a generator:

```sh
$ bin/rails generate godmin:resource article title published
```

Or for an engine install:
```sh
$ admin/bin/rails generate godmin:resource article title published
```

This does a number of things.

It inserts a route in the `config/routes.rb` file:

```ruby
godmin do
  resources :articles
end
```

It creates a controller:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resources::ResourceController
end
```

It creates a service object:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  attrs_for_index :title, :published
  attrs_for_form :title, :published
end
```

Using `attrs_for_index` we can control what fields are displayed in the table listing, and using `attrs_for_form` we can control what fields are available in the new and edit forms. We can, for instance, add the `body` field to `attrs_for_form` to make it appear in forms:

```ruby
attrs_for_form :title, :body, :published
```

By now we have a basic admin interface for managing articles.

## Resources

As we saw in the example above, resources are divided into controllers and, for the lack of a better term, service objects.  Actions, redirects, params permitting etc go in the controller while resource fetching, building, sorting, filtering etc go in the service object. This makes the service objects small and easy to test.

We have already seen two methods at play: `attrs_for_index` and `attrs_for_form`. We will now look at some additional resource concepts.

### Scopes

Scopes are a way of sectioning resources, useful for quick navigation, and can be created as follows:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  scope :unpublished, default: true
  scope :published

  def scope_unpublished(resources)
    resources.where(published: false)
  end

  def scope_published(resources)
    resources.where(published: true)
  end
end
```

### Filters

Filters offer great flexibility when it comes to searching for resources, and can be created as follows:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  filter :title

  def filter_title(resources, value)
    resources.where("title LIKE ?", "%#{value}%")
  end
end
```

There are four types of filters: `string`, `select`, `multiselect` and `checkboxes`, specified using the `as` parameter.

When using `select` or `multiselect`, a collection must be specified. The collection must conform to the format used by Rails `options_for_select` helpers. It can be either an array consisting of name/value tuples, or a collection of ActiveRecords.

```ruby
filter :category, as: :select, collection: -> { [["News", 1], ["Posts", 2]] }
```

When specifying a collection of ActiveRecords, two additional parameters, `option_text` and `option_value` can be specified. They default to `to_s` and `id` respectively.

```ruby
filter :category, as: :select, collection: -> { Category.all }, option_text: "title"
```

### Batch actions

Batch actions can be created as follows:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  batch_action :publish
  batch_action :unpublish
  batch_action :destroy, confirm: true

  def batch_action_publish(resources)
    resources.each(&:publish!)
  end
end
```

In addition, batch actions can be defined per scope using `only` and `except`:

```ruby
batch_action :publish, only: [:unpublished]
batch_action :unpublish, only: [:published]
```

If you wish to implement your own redirect after a batch action, it needs to be implemented in the controller:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resources::ResourceController
  
  def redirect_after_batch_action_publish
    redirect_to articles_path(scope: :published)
  end
end
```

### Resource fetching, building and saving

Resources are made available to the views through instance variables. The index view can access the resources using `@resources` while show, new and edit can access the single resource using `@resource`. In addition, the resource class is available as `@resource_class` and the service object is available as `@resource_service`.

In order to modify resource fetching and construction, these methods can be overridden per resource service:

- `resource_class`
- `resources_relation`
- `resources`
- `find_resource`
- `build_resource`
- `create_resource`
- `update_resource`

To change the class name of the resource from the default based on the service class name:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  def resource_class
    FooArticle
  end
end
```

To scope resources, e.g. based on the signed in user:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  # The signed in admin user is available to all service objects via the options hash
  def resources_relation
    options[:admin_user].articles
  end
end
```

To add to the resources query, e.g. to change the default order:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  def resources
    super.order(author: :desc)
  end
end
```

To change the way a resource is fetched for `show`, `edit`, `update` and `destroy` actions:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  def find_resource(id)
    resources_relation.find_by(slug: id)
  end
end
```

To change the way a resource is constructed for `new` and `create` actions:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  def build_resource(_params)
    article = super
    article.setup_more_things
    article
  end
end
```

To change the way a resource is saved in the `create` action:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  # This method should return true or false
  def create_resource(resource)
    resource.save_in_some_interesting_way
  end
end
```

To change the way a resource is saved in the `update` action:

```ruby
class ArticleService
  include Godmin::Resources::ResourceService

  # This method should return true or false
  def update_resource(resource, params)
    resource.assign_attributes(params)
    resource.save_in_some_interesting_way
  end
end
```

### Redirecting

By default the user is redirected to the resource show page after create and update, and to the index page after destroy. To change this, there are four controller methods that can be overridden: `redirect_after_create`, `redirect_after_update`, `redirect_after_save`, and `redirect_after_destroy`.

For instance, to have the article controller redirect to the index page after both create and update:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resources::ResourceController

  def redirect_after_save
    articles_path
  end
end
```

Or, to have the article controller redirect to the index page after create and the edit page after update:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resources::ResourceController

  def redirect_after_create
    articles_path
  end

  def redirect_after_update
    edit_article_path(@resource)
  end
end
```

If you wish to change the behaviour for every resource controller, consider creating a common resource controller that your other controllers can inherit from:

```ruby
class ResourceController < ApplicationController
  include Godmin::Resources::ResourceController

  protected

  def redirect_after_save
    resource_class.model_name.route_key.to_sym
  end
end
```

### Pagination

If you wish to change the number of resources per page, you can override the `per_page` method in the service object:

```ruby
class ArticlesService
  include Godmin::Resources::Service

  def per_page
    50
  end
end
```

## Views

It's easy to override view templates and partials in Godmin, both globally and per resource. All you have to do is place a file with an identical name in your `app/views` directory. For instance, to override the `godmin/resource/index.html.erb` template for all resources, place a file under `app/views/resource/index.html.erb`. If you only wish to override it for articles, place it instead under `app/views/articles/index.html.erb`.

If you wish to customize the content of a table column, you can place a partial under `app/views/{resource}/columns/{column_name}.html.erb`, e.g. `app/views/articles/columns/_title.html.erb`. The resource is available to the partial through the `resource` variable.

Oftentimes, the default form provided by Godmin doesn't cut it. The `godmin/resource/_form.html.erb` partial is therefore one of the most common to override per resource. See below for more on form building.

Likewise, the `godmin/shared/_navigation.html.erb` partial can be overridden to build a custom navigation bar.

The full list of templates and partials that can be overridden [can be found here](https://github.com/varvet/godmin/tree/master/app/views/godmin).

### Forms

Godmin comes with its own FormBuilder that automatically generates bootstrapped markup. It is based on the [Rails Bootstrap Forms](https://github.com/bootstrap-ruby/rails-bootstrap-forms) FormBuilder, and all its methods are directly available. In addition it has a few convenience methods that can be leveraged.

The `input` method will automatically detect the type of field from the database and generate an appropriate form field:

```ruby
form_for @resource do |f|
  f.input :attribute
end
```

## Authentication

Multiple authentication scenarios are supported. Godmin comes with a lightweight built in authentication solution that can be used to sign in to the admin section via the admin interface. In addition, when running an admin engine, it is possible to set up a shared authentication solution so that administrators can sign in via the main app.

### Built in authentication

This example uses the built in authentication solution. Authentication is isolated to the admin section and administrators sign in via the admin interface.

Godmin comes with a generator that creates an admin user model and enables the built in authentication:

```sh
$ bin/rails generate godmin:authentication
$ bin/rake db:migrate
```

Please note: when installing to an admin engine, the migration needs to be moved to the main app before it can be found by `db:migrate`. Rails has a solution in place for this:

```sh
$ admin/bin/rails generate godmin:authentication
$ bin/rake admin:install:migrations
$ bin/rake db:migrate
```

A model is generated:

```ruby
class AdminUser < ActiveRecord::Base
  include Godmin::Authentication::User

  def self.login_column
    :email
  end
end
```

By default the model is generated with an `email` field as the login column. This can changed in the migration prior to migrating if, for instance, a `username` column is more appropriate.

The following route is generated:

```ruby
resource :session, only: [:new, :create, :destroy]
```

Along with a sessions controller:

```ruby
class SessionsController < ApplicationController
  include Godmin::Authentication::SessionsController
end
```

Finally, the application controller is modified:

```ruby
class ApplicationController < ActionController::Base
  include Godmin::ApplicationController
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end
end
```

Authentication is now required when visiting the admin section.

### Shared authentication

This example uses [Devise](https://github.com/plataformatec/devise) to set up a shared authentication solution between the main app and an admin engine. Administrators sign in and out via the main application.

There is no need to run a generator in this instance. Simply add the authentication module to the admin application controller like so:

```ruby
module Admin
  class ApplicationController < ActionController::Base
    include Godmin::ApplicationController
    include Godmin::Authentication
  end
end
```

Provided you have `User` model set up with Devise in the main application, override the following three methods in the admin application controller:

```ruby
module Admin
  class ApplicationController < ActionController::Base
    include Godmin::ApplicationController
    include Godmin::Authentication

    def authenticate_admin_user
      authenticate_user!
    end

    def admin_user
      current_user
    end

    def admin_user_signed_in?
      user_signed_in?
    end
  end
end
```

The admin section is now authenticated using Devise.

## Authorization

In order to enable authorization, authentication must first be enabled. See the previous section. The Godmin authorization system is heavily inspired by [Pundit](https://github.com/elabs/pundit) and implements the same interface.

Add the authorization module to the application controller:

```ruby
class ApplicationController < ActionController::Base
  include Godmin::ApplicationController
  include Godmin::Authentication
  include Godmin::Authorization

  ...
end
```

Policies can be generated using the following command:

```sh
$ bin/rails generate godmin:policy article
```

This file `app/policies/article_policy.rb` will be created:

```ruby
class ArticlePolicy < Godmin::Authorization::Policy
end
```

Permissions are specified by implementing methods on this class. Two methods are available to the methods, `user` and `record`, the signed in user and the record being authorized. An implemented policy can look something like this:

```ruby
class ArticlePolicy < Godmin::Authorization::Policy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.editor?
  end

  def update?
    user.editor? && record.unpublished?
  end

  def destroy?
    update?
  end
end
```

That is, everyone can list and view articles, only editors can create them, and only unpublished articles can be updated and destroyed.

When a user is not authorized to access a resource, a `NotAuthorizedError` is raised. By default this error is rescued by Godmin and turned into a status code `403 Forbidden` response.
If you want to change this behaviour you can rescue the error yourself in the appropriate `ApplicationController`:

```ruby
module Admin
  class ApplicationController < ActionController::Base
    include Godmin::ApplicationController
    include Godmin::Authentication
    include Godmin::Authorization

    # Renders 404 page and returns status code 404.
    rescue_from NotAuthorizedError do
      render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    end
  end
end
```

## Localization

Godmin supports localization out of the box. Strings can be translated both globally and per resource, similar to how views work.

For a list of translatable strings, [look here](https://github.com/varvet/godmin/blob/master/config/locales/en.yml).

For instance, to translate the `godmin.batch_actions.buttons.select_all` string globally:

```yml
godmin:
  batch_actions:
    buttons:
      select_all: {translation}
```

Or, translate for a specific resource:

```yml
godmin:
  article:
    batch_actions:
      buttons:
        select_all: {translation}
```

In addition, all scopes, filters and batch actions that are added, can be localized:

```yml
godmin:
  article:
    batch_actions:
      labels:
        publish: {translation}
        unpublish: {translation}
    filters:
      labels:
        title: {translation}
    scopes:
      labels:
        unpublished: {translation}
        published: {translation}
```

Godmin comes with built in support for English and Swedish.

There is a view helper available named `translate_scoped` that can be used in overridden views. Please see the source code for information on how to use it.

## JavaScript

Godmin comes with a small set of JavaScript components and APIs.

### Datetimepickers

Make a [bootstrap-datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker) out of a text field:

```ruby
f.date_field :date
f.datetime_field :date
```

If the field is added post page render, it can be initialized manually:

```js
Godmin.Datetimepickers.initializeDatepicker($el);
Godmin.Datetimepickers.initializeTimepicker($el);
Godmin.Datetimepickers.initializeDatetimepicker($el);
```

Additional options can be passed down to bootstrap-datetimepicker:

```js
Godmin.Datetimepickers.initializeDatetimepicker($el, {
  useMinutes: false,
  useSeconds: false
});
```

If you wish to translate the datetimepicker, add the following to your `app/assets/javascripts/application.js`:

```js
//= require moment
//= require moment/{locale} // e.g. moment/sv
//= require godmin
```

### Select boxes

Make a [selectize.js](http://brianreavis.github.io/selectize.js/) select box out of a text field or select box:

```ruby
f.select :authors, Author.all, {}, data: { behavior: "select-box" }
f.text_field :tag_list, data: { behavior: "select-box" }
```

If the field is added post page render, it can be initialized manually:

```js
Godmin.SelectBoxes.initializeSelectBox($el);
```

Additional options can be passed down to selectize:

```js
Godmin.SelectBoxes.initializeSelectBox($el, {
	create: true
});
```

## Plugins

Some additional features are available as plugins:

- [Godmin Uploads](https://github.com/varvet/godmin-uploads)
- [Godmin Tags](https://github.com/varvet/godmin-tags)

## Contributors

https://github.com/varvet/godmin/graphs/contributors

## License

Licensed under the MIT license. See the separate MIT-LICENSE file.

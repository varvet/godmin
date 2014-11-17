# Godmin

[![Build Status](https://travis-ci.org/varvet/godmin.svg?branch=master)](https://travis-ci.org/varvet/godmin)

Godmin is an admin engine for Rails 4+.

- [Installation](#installation)
	- [Standalone installation](#standalone-installation)
	- [Engine installation](#engine-installation)
	- [Installation artefacts](#installation-artefacts)
- [Getting started](#getting-started)
- [Controllers](#controllers)
	- [Scopes](#scopes)
	- [Filters](#filters)
	- [Batch actions](#batch-actions)
	- [Resource fetching](#resource-fetching)
- [Views](#views)
- [Models](#models)
- [Authentication](#authentication)
	- [Simple authentication](#simple-authentication)
	- [Shared authentication](#shared-authentication)
- [Authorization](#authorization)
- [Localization](#localization)
- [Contributors](#contributors)

## Installation

Godmin supports two common admin scenarios:

1. Standalone installation
2. Engine installation

### Standalone installation
For admin-only applications, or for architectures where the admin lives in its own app, i.e. you want to access the admin section at `localhost:3000`.

Add the gem to the application's `Gemfile`:
```ruby
gem "godmin"
```

Run the install generator:
```sh
$ bin/rails generate godmin:install
```

Godmin should be up and running at `localhost:3000`

### Engine installation
For when the admin is part of the same codebase as the main application, i.e. you want to access the admin section at `localhost:3000/admin`.

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
mount Admin::Engine, at: "/admin"
```

Add the gem to the engine's gemspec, `admin/admin.gemspec`:
```ruby
s.add_dependency("godmin", "~> 1.0.0")
```

Run the install generator within the scope of the engine, i.e. note the leading `admin/`:
```sh
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

Resource routes placed within the `godmin` block are automatically added to the default navigation, and set up to work with batch actions. More on this in later sections.

The application controller is modified as such:
```ruby
class ApplicationController < ActionController::Base
  include Godmin::Application
end
```

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

First, it inserts a route in the `config/routes.rb` file that looks like this:

```ruby
godmin do
  resources :articles
end
```

Second, it creates a controller that looks something like this:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resource

  def attrs_for_index
    [:title, :published]
  end

  def attrs_for_form
    [:title, :published]
  end
end
```

Using `attrs_for_index` we can control what fields are displayed in the table listing, and using `attrs_for_form` we can control what fields are available in the new and edit forms. We can, for instance, add the `body` field to `attrs_for_form` to make it appear in forms:

```ruby
def attrs_for_form
  [:title, :body, :published]
end
```

By now we have a basic admin interface for managing articles.

## Controllers

We have already seen two controller methods at play: `attrs_for_index` and `attrs_for_form`. Now we will look at four additional controller concepts, namely:

- Scopes
- Filters
- Batch actions
- Resource fetching

### Scopes

Scopes are a way of sectioning resources, useful for quick navigation, and can be created as follows:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resource

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

Filters offer great flexibility when it comes to searching for resources.

Filters can be created as follows:

```ruby
class ArticlesController < ApplicationController
  include Godmin::Resource

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
class ArticlesController < ApplicationController
  include Godmin::Resource

  batch_action :publish
  batch_action :unpublish
  batch_action :destroy, confirm: true

  def batch_action_publish(resources)
    resources.each { |r| r.update_attributes(published: true) }
  end

  ...
end
```

In addition, batch actions can be defined per scope using `only` and `except`:

```ruby
batch_action :publish, only: [:unpublished]
batch_action :unpublish, only: [:published]
```

If you wish to implement your own redirect after a batch action, return false afterwards:

```ruby
def batch_action_publish(resources)
  resources.each { |r| r.update_attributes(published: true) }
  redirect_to articles_path(scope: published) and return false
end
```

### Resource fetching

Resources are made available to the views through instance variables. The index view can access the resources using `@resources` while show, new and edit can access the single resource using `@resource`.

In order to modify what resources to fetch, there are three methods that can be overridden per resource controller:

- `resource_class`
- `resource_relation`
- `resources`

To change the class name of the resource from the default based on the controller name:

```ruby
class ArticlesController
  include Godmin::Resource

  def resource_class
    FooArticle
  end
end
```

To scope resources, e.g. based on the signed in user:

```ruby
class ArticlesController
  include Godmin::Resource

  def resources_relation
    admin_user.articles
  end
end
```

To add to the resources query, e.g. to change the default order:

```ruby
class ArticlesController
  include Godmin::Resource

  def resources
    super.order(author: :desc)
  end
end
```

## Views

It is easy to override view templates and partials in Godmin, both globally and per resource. All you have to do is place a file with an identical name in your `app/views` directory. For instance, to override the `godmin/resource/index.html.erb` template for all resources, place a file under `app/views/resource/index.html.erb`. If you only wish to override it for articles, place it instead under `app/views/articles/index.html.erb`.

If you wish to customize the content of a table column, you can place a partial under `app/views/{resource}/columns/{column_name}.html.erb`, e.g. `app/views/articles/columns/_title.html.erb`. The resource is available to the partial through the `resource` variable.

Oftentimes, the default form provided by Godmin doesn't cut it. The `godmin/resource/_form.html.erb` partial is therefore one of the most common to override per resource.

Likewise, the `godmin/shared/_navigation.html.erb` partial can be overridden to build a custom navigation bar.

The full list of templates and partials that can be overridden [can be found here](https://github.com/varvet/godmin/tree/master/app/views/godmin)

## Models

## Authentication

Multiple authentication scenarios are supported. Godmin comes with a built in authentication solution that can be used to sign in to the admin section via the admin interface. In addition, when running an admin engine, it is possible to set up a shared authentication solution so that administrators can sign in via the main app.

### Simple authentication

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

The generated model looks like this:

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
  include Godmin::Authentication::Sessions
end
```

Finally, the application controller is tweaked to look something like this:

```ruby
class ApplicationController < ActionController::Base
  include Godmin::Application
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end
end
```

Authentication is now required when visiting the admin section.

### Shared authentication

This example uses [Devise](https://github.com/plataformatec/devise) to set up a shared authentication solution between the main app and an admin engine. Administrators sign in and out via the main application.

There is no need to run a generator in this instance. Simple add the authentication module to the admin application controller like so:

```ruby
module Admin
  class ApplicationController < ActionController::Base
    include Godmin::Application
    include Godmin::Authentication
  end
end
```

Provided you have `User` model set up with Devise in the main application, override the following three methods in the admin application controller:

```ruby
module Admin
  class ApplicationController < ActionController::Base
    include Godmin::Application
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

That's it. The admin section is now authenticated using Devise.

## Authorization

In order to enable authorization, authentication must first be enabled. See the previous section. The Godmin authorization system is heavily inspired by [Pundit](https://github.com/elabs/pundit) and implements the same interface.

Add the authorization module to the application controller:

```ruby
class ApplicationController < ActionController::Base
  include Godmin::Application
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

## Localization

Godmin supports localization out of the box. Strings can be translated both globally and per resource, similar to how views work.

For a list of translatable strings, [look here](https://github.com/varvet/godmin/blob/resurrection/config/locales/en.yml).

For instance, to translate the `godmin.batch_actions.select_all` string globally:

```yml
godmin:
  batch_actions:
    select_all: {translation}
```

Or, translate for a specific resource:

```yml
godmin:
  articles:
    batch_actions:
      select_all: {translation}
```

In addition, all scopes, filters and batch actions that are added, can be localized:

```yml
godmin:
  articles:
    batch_actions:
      publish: {translation}
      unpublish: {translation}
    filters:
      labels:
        title: {translation}
    scopes:
      unpublished: {translation}
      published: {translation}
```

Godmin comes with built in support for English and Swedish.

There is a view helper available named `translated_scoped` that can be used in overridden views. Please see the source code for information on how to use it.

## Contributors

# Godmin

Godmin is an admin engine for Rails 4+.

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

## Models

## Authentication & authorization

## Localization

## Contributors

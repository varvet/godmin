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

## Getting started

Godmin deals primarily with resources. A resource is something that can be administered through the Godmin user interface, often a Rails model. Let's say the application has an Article model with attributes such as `title`, `body` and `published`. To get going quickly, we can use a generator:

```sh
$ bin/rails generate godmin:resource article title published 
```

Or for an engine install:
```sh
$ admin/bin/rails generate godmin:resource article title published 
```

This does a number of things.

First, it inserts a route in the ``config/routes.rb`` file that looks like this:

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

Using `attrs_for_index` we can control what fields are displayed in the table listing, and using `attrs_for_form` we can control what fields are available in the new and edit forms. We can, for instance, add the `body` field to `attrs_for_form` to make it editable:

```ruby
def attrs_for_form
  [:title, :body, :published]
end
```

By now we have a basic admin interface for managing articles.

## Controllers

## Views

## Models

## Authentication & authorization

## Localization

## Contributors

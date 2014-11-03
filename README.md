# Godmin

Godmin is an admin engine for Rails 4+.

## Installation

Godmin supports two common admin scenarios:

1) Standalone installation. For admin-only applications, or in architectures where the admin lives in its own app.
2) Engine installation. For when the admin is part of the same codebase as the main application.

### Standalone installation

Add the gem to the application's Gemfile:
```
gem "godmin"
```

Run the install generator:
```
$ rails generate godmin:install
```

### Engine installation

Generate a [mountable engine](http://guides.rubyonrails.org/engines.html):
```
$ rails plugin new admin --mountable
```

Add it to your Gemfile:
```
gem "admin", path: "admin"
```

Mount it in your `config/routes.rb`:
```
mount Admin::Engine, at: "/admin"
```

Add the godmin gem to your engine's gemspec, `admin/admin.gemspec`:
```
s.add_dependency("godmin", "~> 1.0.0")
```

Run the install generator within the engine:
```
$ admin/bin/rails generate godmin:install
```

## Getting started

## Controllers

## Views

## Authentication & authorization

## Localization

## Contributors

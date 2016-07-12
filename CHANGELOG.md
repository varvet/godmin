# Changelog

### 1.3.0 - 2016-07-11
Features
- Increased batch action checkbox click area (https://github.com/varvet/godmin/pull/183)
- Adds titles to action links (https://github.com/varvet/godmin/pull/185)
- Rails 5 support (https://github.com/varvet/godmin/pull/199)

Bug fixes
- Use translated title on login page (https://github.com/varvet/godmin/pull/195)
- Hide batch action toggle when no batch action available (https://github.com/varvet/godmin/pull/197)
- Remove hidden field for multiselect filters (https://github.com/varvet/godmin/pull/169)

Other
- Fixes a deprecation warning on Rails 4.2.5.1 (https://github.com/varvet/godmin/pull/188)
- Adds caching partial overrides to increase table rendering speed (https://github.com/varvet/godmin/pull/184)

### 1.2.0 - 2016-02-02
Features
- Adds support for custom ordering of columns (https://github.com/varvet/godmin/pull/168)
- Adds passing of options to association form helper (https://github.com/varvet/godmin/pull/172)
- Adds passing of html options to association form helper (https://github.com/varvet/godmin/pull/176)

Bug fixes
- Fixes an issue with the template resolver and Rails 4.2.5.1 (https://github.com/varvet/godmin/pull/175)

### 1.1.0 - 2015-12-08
Features
- Adds locale for pt-BR (Brazilian Portuguese) (https://github.com/varvet/godmin/pull/141)
- New sandbox template with with more examples (https://github.com/varvet/godmin/pull/135)
- Permits belongs to association by default (https://github.com/varvet/godmin/pull/149)
- Enables responsive design (https://github.com/varvet/godmin/pull/146)
- Batch actions now receive a relation instead of an array (https://github.com/varvet/godmin/pull/158)

Bug fixes
- Fixes a bug that masked errors in templates with a template not found error (https://github.com/varvet/godmin/pull/142)
- Fixes a namespace issue with the authentication generator (https://github.com/varvet/godmin/pull/150)

### 1.0.0 - 2015-11-13
Release of 1.0.0 :tada:

### 0.12.4 - 2015-10-21
Bug fixes
- Fixes a bug which made it impossible to override the datetimepicker locale (https://github.com/varvet/godmin/issues/132)

### 0.12.3 - 2015-09-18
Bug fixes
- Adds support for plural engines (https://github.com/varvet/godmin/pull/128)
- Remove turbolinks from application.js if present (https://github.com/varvet/godmin/issues/129)

### 0.12.2 - 2015-09-07
Bug fixes
- Fixes broken sign in page

### 0.12.1 - 2015-09-07
Bug fixes
- Fixes issue where column ordering on index table didn't work (https://github.com/varvet/godmin/issues/124)

Other
- Adds integration tests
- Removes the namespace config in `initializers/godmin.rb`

In order to upgrade:
- Remove the `initializers/godmin.rb` file

### 0.12.0 - 2015-06-30
Features
- Adds new navigation helpers for building a custom navbar (https://github.com/varvet/godmin/issues/54)

Other
- Removes the godmin router method

In order to upgrade:
- Remove the `godmin do` block from the `config/routes.rb` file
- Specify a root route if there is none already
- Create a `shared/_navigation.html.erb` partial if there is none already

Bug fixes
- Fixes issue with authentication generator not modifying the application controller

### 0.11.2 - 2015-06-22
Bug fixes
- Fixes broken collection select helper

### 0.11.1 - 2015-05-20
Features
- Adds `destroy_resource` method to `ResourceService`
- Adds query param to authorize
- Adds authorization to batch actions (https://github.com/varvet/godmin/issues/33)
- Adds show page (https://github.com/varvet/godmin/issues/77)
- Adds option to change add text on dropdowns (https://github.com/varvet/godmin/pull/106)
- Adds CSV export (https://github.com/varvet/godmin/issues/86)
- JSON export can now be controlled using `attrs_for_export` or by overriding a jbuilder

Bug fixes
- Fixes a regression where filter labels were not translated

### 0.11.0 - 2015-04-13
Other
- Split resources into controllers and service objects (https://github.com/varvet/godmin/pull/79)
- Renames the following modules:
  - Godmin::Application -> Godmin::ApplicationController
  - Godmin::Resource -> Godmin::Resources::ResourceController
  - Godmin::Sessions -> Godmin::SessionsController

### 0.10.3 - 2015-02-18
Bug fixes
- Adds the possibility to pass options to the `date_field` and `datetime_field` form helpers

### 0.10.2 - 2015-02-16
Bug fixes
- Fixes standard resource params for multi-word models

### 0.10.1 - 2015-02-13
Bug fixes
- Fixes multi-select selectize issue (https://github.com/varvet/godmin/issues/71)

### 0.10.0 - 2015-02-11
Features
- Shows the number of items in each scope in the scope tab (https://github.com/varvet/godmin/issues/16)
- Two new overridable methods for resources: `build_resource` and `find_resource`
- Translatable title (https://github.com/varvet/godmin/issues/17)

Bug fixes
- Fixes a bug where the wrong template would be picked (https://github.com/varvet/godmin/issues/39)
- Fixes a bug so the resolver works with namespaces templates.
- Fixes an autoloading issue (https://github.com/varvet/godmin/issues/60)
- Godmin rescues `NotAuthorizedError` and returns a 403 Forbidden HTTP status.

Other
- Cleaned up generators (https://github.com/varvet/godmin/issues/28)
- Restructured the locale files a bit

### 0.9.9 - 2015-01-23
Features
- Bump bootstrap to 3.3.3
- Extracted button actions partial

### 0.9.8 - 2015-01-12
Bug fixes
- Created resources are now properly scoped by `resources_relation`
- Fixes broken signin form

### 0.9.7 - 2015-01-07
Features
- Support for Rails 4.2
- New form system (https://github.com/varvet/godmin/pull/50)

### 0.9.6 - 2014-12-18
Features
- Bundled [datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker/)
- Exposed JavaScript API

Notes
- You must now require godmin in application.js and application.css
- You can no longer use the `select-tag` class to initialize a select box

### 0.9.5 - 2014-12-15
Bug fixes
- Fixes Godmin::FormBuilder issue

### 0.9.4 - 2014-12-15
Features
- Added Godmin::FormBuilder

### 0.9.3 - 2014-12-10
Bug fixes
- Pagination offset fix

### 0.9.2 - 2014-12-09
Features
- Replaces select2 with [selectize](http://brianreavis.github.io/selectize.js/)
- Adds flash messages (https://github.com/varvet/godmin/issues/26)
- Adds redirect hooks (https://github.com/varvet/godmin/issues/27)
- Replaces kaminari

Bug fixes
- Form fallbacks to regular input instead of association. (https://github.com/varvet/godmin/issues/18)
- Install generator adds `require "godmin"` if it is installed in an engine.
- Fixes default permitted params to work with multiword models.

### 0.9.1 - 2014-11-18
Bug fixes
- Removed rails executable from /bin folder.

### 0.9.0 - 2014-11-17

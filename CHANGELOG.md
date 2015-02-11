# Changelog

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

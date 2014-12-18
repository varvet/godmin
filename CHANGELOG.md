# Changelog

### 0.9.6 - 2014-12-18
Features
- Bundled [datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker/)
- Exposed JavaScript API

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
Public release.

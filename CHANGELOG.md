# Changelog

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

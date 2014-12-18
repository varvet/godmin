window.Godmin = window.Godmin || {};

Godmin.Selects = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    initializeSelect($('.select-tag'));
  }

  function initializeSelect($el, options) {
    var defaults = {
      inputClass: 'form-control selectize-input'
    };

    $el.selectize($.extend(defaults, options));
  }

  return {
    initialize: initialize,
    initializeSelect: initializeSelect
  };
})();

$(function() {
  Godmin.Selects.initialize();
});

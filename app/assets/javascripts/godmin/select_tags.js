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

  function initializeSelect($el) {
    $el.selectize({
      inputClass: 'form-control selectize-input'
    });
  }

  return {
    initialize: initialize,
    initializeSelect: initializeSelect
  };
})();

$(function() {
  Godmin.Selects.initialize();
});

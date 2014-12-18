window.Godmin = window.Godmin || {};

Godmin.SelectBoxes = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    initializeSelectBox($('[data-behavior=select-box]'));
  }

  function initializeSelectBox($el, options) {
    var defaults = {
      inputClass: 'form-control selectize-input'
    };

    $el.selectize($.extend(defaults, options));
  }

  return {
    initialize: initialize,
    initializeSelectBox: initializeSelectBox
  };
})();

$(function() {
  Godmin.SelectBoxes.initialize();
});

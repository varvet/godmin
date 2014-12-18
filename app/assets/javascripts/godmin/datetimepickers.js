window.Godmin = window.Godmin || {};

Godmin.Datetimepickers = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    initializeDatetimepicker($('[data-behavior=datetimepicker]'));
  }

  function initializeDatetimepicker($el) {
    $el.datetimepicker();
  }

  return {
    initialize: initialize,
    initializeDatetimepicker: initializeDatetimepicker
  };
})();

$(function() {
  Godmin.Datetimepickers.initialize();
});

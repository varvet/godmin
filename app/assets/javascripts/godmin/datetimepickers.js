window.Godmin = window.Godmin || {};

Godmin.Datetimepickers = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    initializeDatepicker($('[data-behavior=datepicker]'));
    initializeTimepicker($('[data-behavior=timepicker]'));
    initializeDatetimepicker($('[data-behavior=datetimepicker]'));
  }

  function initializeDatepicker($el, options) {
    var defaults = {
      pickTime: false
    };
    initializeDatetimepicker($el, $.extend(defaults, options));
  }

  function initializeTimepicker($el, options) {
    var defaults = {
      pickDate: false
    };
    initializeDatetimepicker($el, $.extend(defaults, options));
  }

  function initializeDatetimepicker($el, options) {
    var defaults = {};
    $el.datetimepicker($.extend(defaults, options));
  }

  return {
    initialize: initialize,
    initializeDatepicker: initializeDatepicker,
    initializeTimepicker: initializeTimepicker,
    initializeDatetimepicker: initializeDatetimepicker
  };
})();

$(function() {
  Godmin.Datetimepickers.initialize();
});

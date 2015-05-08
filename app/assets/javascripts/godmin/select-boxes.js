window.Godmin = window.Godmin || {};

Godmin.SelectBoxes = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    initializeSelectBox($('[data-behavior~=select-box]'));
  }

  function initializeSelectBox($el, options) {
    var defaults = {
      inputClass: 'selectize-input',
      render: {
        option_create: function(data, escape) {
          return '<div class="create">' + (this.$input.data("add-label") || "+") + ' <strong>' + escape(data.input) + '</strong>&hellip;</div>';
        }
      }
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

window.Godmin = window.Godmin || {};

Godmin.Navigation = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    removeEmptyDropdowns();
  }

  function removeEmptyDropdowns() {
    $('.navbar-nav .dropdown').each(function() {
      if ($(this).find('li').length === 0) {
        $(this).remove();
      }
    });
  }

  return {
    initialize: initialize
  };
})();

$(function() {
  Godmin.Navigation.initialize();
});

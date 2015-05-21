window.Godmin = window.Godmin || {};

Godmin.Navigation = (function() {
  function initialize() {
    initializeEvents();
    initializeState();
  }

  function initializeEvents() {}

  function initializeState() {
    setActiveLink();
    removeEmptyDropdowns();
  }

  function setActiveLink() {
    var $links = $('.nav.navbar-nav a[href="' + window.location.pathname + window.location.search + '"]');

    if ($links.length === 0 ) {
      addActiveClass($('.nav.navbar-nav a[href="' + window.location.pathname + '"]'));
    } else {
      addActiveClass($links);
    }
  }

  function addActiveClass($links) {
    $links.closest('li').addClass('active');
    $links.closest('li.dropdown').addClass('active');
  }

  function removeEmptyDropdowns() {
    $('.navbar-nav .dropdown, .breadcrumb .dropdown').each(function() {
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

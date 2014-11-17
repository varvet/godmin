(function($) {
  $(function() {
    $('.navbar-nav .dropdown').each(function() {
      if ($(this).find('li').length === 0) {
        $(this).remove();
      }
    });
  });
}(jQuery));

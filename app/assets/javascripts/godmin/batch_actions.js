(function($){
  $(function(){

    $form = $('#batch-process-form');

    $form.find('input:checkbox').on('click', function(){
      if ($form.find('input:checkbox:checked').length) {
        if ($('.batch-process-action-link').css("visibility") == "hidden") {
          $('.batch-process-action-link').hide().css({visibility: "visible"}).fadeIn();
        } 
      } else {
        $('.batch-process-action-link').css('visibility','hidden')
      }
    });

    $(document).delegate('.batch-process-action-link', 'click.rails', function(){
      $form.find('#batch-process-action').val($(this).data('value'));
      $form.submit();
    });

  });
}(jQuery));

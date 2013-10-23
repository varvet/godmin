(function($){
  $(function(){

    $form = $('#batch-process-form');

    $form.find('input:checkbox').on('click', function(){
      if ($form.find('input:checkbox:checked').length) {
        $('.batch-process-action-link').removeClass('disabled');
      } else {
        $('.batch-process-action-link').addClass('disabled');
      }
    });

    $(document).delegate('.batch-process-action-link', 'click.rails', function(){
      $form.find('#batch-process-action').val($(this).data('value'));
      $form.submit();
    });

  });
}(jQuery));

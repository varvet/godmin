(function($){
  $(function(){
    $(document).delegate('.batch-process-action-link', 'click.rails', function(){
      $form = $('#batch-process-form');
      $form.find('#batch-process-action').val($(this).data('value'));
      $form.submit();
    });
  });
}(jQuery));

(function($){
  $(function(){

    $form       = $('#batch-process-form');
    $selectAll  = $form.find('.batch-process-select-all');
    $selectNone = $form.find('.batch-process-select-none');

    var setSelectToAll = function() {
      $selectAll.removeClass('hidden');
      $selectNone.addClass('hidden');
    };

    var setSelectToNone = function() {
      $selectAll.addClass('hidden');
      $selectNone.removeClass('hidden');
    };

    $form.find('.batch-process-select').on('click', function(){
      if ($form.find('input:checkbox:checked').length > 0) {
        $form.find('input:checkbox').prop('checked', false).trigger('change');
        setSelectToAll();
      } else {
        $form.find('input:checkbox').prop('checked', true).trigger('change');
        setSelectToNone();
      }
    });

    $form.find('input:checkbox').on('change', function(){
      if ($form.find('input:checkbox:checked').length) {
        $('.batch-process-action-link').removeClass('hidden');
        setSelectToNone();
      } else {
        $('.batch-process-action-link').addClass('hidden');
        setSelectToAll();
      }
    });

    $(document).delegate('.batch-process-action-link', 'click.rails', function(){
      $form.find('#batch-process-action').val($(this).data('value'));
      $form.submit();
    });

  });
}(jQuery));

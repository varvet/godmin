(function($) {
  $(function() {
    $form       = $('#batch-actions-form');
    $selectAll  = $form.find('.batch-actions-select-all');
    $selectNone = $form.find('.batch-actions-select-none');

    var setSelectToAll = function() {
      $selectAll.removeClass('hidden');
      $selectNone.addClass('hidden');
    };

    var setSelectToNone = function() {
      $selectAll.addClass('hidden');
      $selectNone.removeClass('hidden');
    };

    $form.find('.batch-actions-select').on('click', function() {
      if ($form.find('input:checkbox:checked').length > 0) {
        $form.find('input:checkbox').prop('checked', false).trigger('change');
        setSelectToAll();
      } else {
        $form.find('input:checkbox').prop('checked', true).trigger('change');
        setSelectToNone();
      }
    });

    $form.find('input:checkbox').on('change', function() {
      if ($form.find('input:checkbox:checked').length) {
        $('.batch-actions-action-link').removeClass('hidden');
        setSelectToNone();
      } else {
        $('.batch-actions-action-link').addClass('hidden');
        setSelectToAll();
      }
    });

    $(document).delegate('.batch-actions-action-link', 'click.rails', function() {
      $form.find('#batch-actions-action').val($(this).data('value'));
      $form.submit();
    });
  });
}(jQuery));

window.Godmin = window.Godmin || {};

Godmin.BatchActions = (function() {
  var $form;
  var $selectAll;
  var $selectNone;

  function initialize() {
    $form       = $('#batch-actions-form');
    $selectAll  = $form.find('.batch-actions-select-all');
    $selectNone = $form.find('.batch-actions-select-none');

    initializeEvents();
    initializeState();
  }

  function initializeEvents() {
    $form.find('.batch-actions-select').on('click', toggleCheckboxes);
    $form.find('input:checkbox').on('change', toggleActions);
    $(document).delegate('.batch-actions-action-link', 'click', triggerAction);
  }

  function initializeState() {}

  function setSelectToAll() {
    $selectAll.removeClass('hidden');
    $selectNone.addClass('hidden');
  }

  function setSelectToNone() {
    $selectAll.addClass('hidden');
    $selectNone.removeClass('hidden');
  }

  function toggleCheckboxes() {
    if ($form.find('input:checkbox:checked').length > 0) {
      $form.find('input:checkbox').prop('checked', false).trigger('change');
      setSelectToAll();
    } else {
      $form.find('input:checkbox').prop('checked', true).trigger('change');
      setSelectToNone();
    }
  }

  function toggleActions() {
    if ($form.find('input:checkbox:checked').length) {
      $('.batch-actions-action-link').removeClass('hidden');
      setSelectToNone();
    } else {
      $('.batch-actions-action-link').addClass('hidden');
      setSelectToAll();
    }
  }

  function triggerAction() {
    $form.find('#batch-actions-action').val($(this).data('value'));
    $form.submit();
  }

  return {
    initialize: initialize
  };
})();

$(function() {
  Godmin.BatchActions.initialize();
});

window.Godmin = window.Godmin || {};

Godmin.BatchActions = (function() {
  var $form;
  var $selectAll;
  var $selectNone;

  function initialize() {
    $form       = $('form[data-behavior~=batch-actions-form]');
    $selectAll  = $form.find('[data-behavior~=batch-actions-select-all]');
    $selectNone = $form.find('[data-behavior~=batch-actions-select-none]');

    initializeEvents();
    initializeState();
  }

  function initializeEvents() {
    $form.find('[data-behavior~=batch-actions-select]').on('click', toggleCheckboxes);
    $form.find('[data-behavior~=batch-actions-checkbox]').on('change', toggleActions);
    $(document).delegate('[data-behavior~=batch-actions-action-link]', 'click', triggerAction);
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
    if ($form.find('[data-behavior~=batch-actions-checkbox]:checked').length > 0) {
      $form.find('[data-behavior~=batch-actions-checkbox]').prop('checked', false).trigger('change');
      setSelectToAll();
    } else {
      $form.find('[data-behavior~=batch-actions-checkbox]').prop('checked', true).trigger('change');
      setSelectToNone();
    }
  }

  function toggleActions() {
    if ($form.find('[data-behavior~=batch-actions-checkbox]:checked').length) {
      $('[data-behavior~=batch-actions-action-link]').removeClass('hidden');
      setSelectToNone();
    } else {
      $('[data-behavior~=batch-actions-action-link]').addClass('hidden');
      setSelectToAll();
    }
  }

  function triggerAction() {
    $form.find('[data-behavior~=batch-actions-action]').val($(this).data('value'));

    var ids = $form.find('[data-behavior~=batch-actions-checkbox]:checked').map(function() {
      return this.id;
    }).toArray().join(',');

    $form.attr('action', $form.attr('action') + '/' + ids);

    $form.submit();
  }

  return {
    initialize: initialize
  };
})();

$(function() {
  Godmin.BatchActions.initialize();
});

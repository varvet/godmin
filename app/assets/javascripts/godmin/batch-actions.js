window.Godmin = window.Godmin || {};

Godmin.BatchActions = (function() {
  var $container;
  var $selectAll;
  var $selectNone;
  var $actionLinks;

  function initialize() {
    $container   = $('[data-behavior~=batch-actions-container]');
    $selectAll   = $container.find('[data-behavior~=batch-actions-select-all]');
    $selectNone  = $container.find('[data-behavior~=batch-actions-select-none]');
    $actionLinks = $container.find('[data-behavior~=batch-actions-action-link]');

    initializeEvents();
    initializeState();
  }

  function initializeEvents() {
    $container.find('[data-behavior~=batch-actions-select]').on('click', toggleCheckboxes);
    $container.find('[data-behavior~=batch-actions-checkbox]').on('change', toggleActions);
    $(document).delegate('[data-behavior~=batch-actions-action-link]', 'mousedown', triggerAction);
  }

  function initializeState() {
    $selectNone.hide();
    $actionLinks.hide();
  }

  function setSelectToAll() {
    $selectAll.show();
    $selectNone.hide();
  }

  function setSelectToNone() {
    $selectAll.hide();
    $selectNone.show();
  }

  function checkedCheckboxes() {
    return $container.find('[data-behavior~=batch-actions-checkbox]:checked').map(function() {
      return this.id.match(/\d+/);
    }).toArray().join(',');
  }

  function toggleCheckboxes(e) {
    e.preventDefault();

    if (checkedCheckboxes().length > 0) {
      $container.find('[data-behavior~=batch-actions-checkbox]').prop('checked', false).trigger('change');
      setSelectToAll();
    } else {
      $container.find('[data-behavior~=batch-actions-checkbox]').prop('checked', true).trigger('change');
      setSelectToNone();
    }
  }

  function toggleActions() {
    if (checkedCheckboxes().length) {
      $actionLinks.show();
      setSelectToNone();
    } else {
      $actionLinks.hide();
      setSelectToAll();
    }
  }

  function triggerAction() {
    $(this).attr('href', $(this).attr('href') + '/' + checkedCheckboxes() + '?batch_action=' + $(this).data('value'));
  }

  return {
    initialize: initialize
  };
})();

$(function() {
  Godmin.BatchActions.initialize();
});

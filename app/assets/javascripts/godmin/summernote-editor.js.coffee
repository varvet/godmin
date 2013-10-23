$ ->

  # to set summernote object
  # You should change '#post_content' to your textarea input id
  summer_note = $('.summernote-editor')

  # to call summernote editor
  summer_note.summernote
    # to set options
    height:300
    toolbar: [
                ["style", ["style"]],
                ["fontsize", ["fontsize"]],
                ["color", ["color"]],
                ["style", ["bold", "italic", "underline", "clear"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["height", ["height"]],
                ["insert", ["picture", "link"]],
                ["table", ["table"]],
                ["view", ["fullscreen", "codeview"]],
                ["help", ["help"]]
             ]

  # to set code for summernote
  summer_note.code summer_note.val()

  # to get code for summernote
  summer_note.closest('form').submit ->
    summer_note.val summer_note.code()[0]
    true

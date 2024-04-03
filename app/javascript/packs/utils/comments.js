const templateElement = require('../../templates/comment.hbs')

$(document).on('turbolinks:load', function() {
    $('.container')
      .on('ajax:success', '.add-comment', handlerSuccess)
      .on('ajax:error', '.add-comment', handlerError)
})

function handlerSuccess(e) {
  const response = e.originalEvent.detail[0]

  $(this).find('.comment-body').val('')
  $(this).parents().children('.comments').append(templateElement(response))
}

function handlerError(e) {
  const response = e.originalEvent.detail[0]

  $('p.alert').empty()

  $.each(response, function(index, value) {
    $('p.alert').append(`<div class='flash-alert'>${value}</div>`)
  })
}

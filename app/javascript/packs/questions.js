$(document).on('turbolinks:load', function() {
  $('.question .question-control').on('click', '.edit-question-link', function(e) {
    e.preventDefault()
    $(this).hide()
    var questionId = $(this).data('questionId')
    $(`form#edit-question-${questionId}`).removeClass('hidden')
  })
})

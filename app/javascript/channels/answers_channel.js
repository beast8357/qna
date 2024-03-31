import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = gon.question_id
  if (!questionId) return

  const answerTemplate = require('../templates/answer.hbs')
  const answersList = $('.answers')

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
    connected() {
      console.log('Connected to answers_channel_' + questionId)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.sid === data.sid) return

      const answerFullTemplate = answerTemplate(data)
      answersList.append(answerFullTemplate)
    }
  })
})

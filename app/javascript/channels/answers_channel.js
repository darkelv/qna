import consumer from "./consumer"

consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
    received(data) {
        this.addAnswer(data);
    },

    addAnswer(data) {
        if (gon.user_id == data.answer.user_id) return;

        const template = require('../views/answer.hbs');

        const answersNode = document.querySelector('.answers');
        data.is_question_author = gon.user_id == gon.question_author_id;

        answersNode.insertAdjacentHTML('beforeEnd', template(data));
    }
});

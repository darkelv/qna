import consumer from "./consumer";

consumer.subscriptions.create({ channel: 'QuestionsChannel' }, {
    received(data) {
        // Called when there's incoming data on the websocket for this channel
        this.addQuestion(data);
    },

    addQuestion(html) {
        const questionList = document.querySelector('.questions');
        questionList.insertAdjacentHTML('beforeEnd', html);
    }
});

$(document).on('turbolinks:load',function() {
    $('.question').on('click', '.edit-question-link', function(e){
        e.preventDefault();
        $(this).hide();
        $('form#edit-question-form').removeClass('hidden');
    });

    $(".question .vote").bind('ajax:success', function(e){
        var response = e.detail[0];
        $(".question .vote").html(response.output);
    });
});

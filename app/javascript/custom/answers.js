$(document).on('turbolinks:load',function() {
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   });

   $(".answers .vote").bind('ajax:success', function(e) {
       var response = e.detail[0];
       $(".answer-" + response.id + " .vote").html(response.output);
   });
});

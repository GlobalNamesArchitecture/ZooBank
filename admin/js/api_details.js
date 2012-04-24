$(function() {
  $(".api_expand_link").click(function(e) {
    e.preventDefault();
    $(this).parent().next().next().next().toggle();
  });
});
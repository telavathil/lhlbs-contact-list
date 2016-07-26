$(document).ready(function() {
  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

  //set the form to be hidden by default
  $('#contact-form').hide();

  //show the form on the click of new
  $(document).on('click','#reveal-form',function(){
    if ($('#contact-form').is(':visible')) {
      $('.form-container').remove();
    }else {
      $('#contact-form').append(contactFormHtml());
    }
    $('#contact-form').toggle();
  });

  //post the contcat data via json
  $(document).on('submit',function(e){
    e.preventDefault();
    debugger;
    alert($(this).serialize());
  });

    // $('form.new_contact button').on('click', function(e) {
    //   e.preventDefault();
    //   var form = $(e.target).parent('form');
    //   debugger;
    // })

  function contactFormHtml(json){
    var source   = $("#form-template").html();
    var template = Handlebars.compile(source);
    var context = json;
    return template(context);
  }

  //write contact to its contact-table-template
  function contactHtml(json){
    var source   = $("#contact-table-template").html();
    var template = Handlebars.compile(source);
    var context = json;
    return template(context);
  }

  //get contacts
  $.get('/contacts', function (data){
      //loop through the data and populate all the contacts
      data.forEach(function(contact){
        $('.contacts-list').append(contactHtml(contact));
      });
  });
});

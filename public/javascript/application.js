$(document).ready(function() {
  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

  // ----------------------------
  // -------On Page load---------
  // ----------------------------

  //set the form to be hidden by default and populate the contact list
  $('#contact-form').hide();
  getContacts();


  // ----------------------------
  // -------Page Events----------
  // ----------------------------

  //show the form on the click of new button
  $(document).on('click','#reveal-form',function(){
    showForm();
  });

  //post the contcat data via json on the submit of the new form
  $(document).on('submit','form.new_contact',function(e){
    e.preventDefault();
    var data = $(this).serializeArray();
    newContact(data);
  });

  //show the form on the click of show button
  $(document).on('click','#show-contact',function(){
    var id = $(this).closest('tr').data('id');
    getContact(id,'show');
  });

  //show the form on the click of edit button
  $(document).on('click','#edit-contact',function(){
    var id = $(this).closest('tr').data('id');
    getContact(id,'edit');
  });

  //post the contcat data via json on the submit of the new form
  $(document).on('submit','form.edit_contact',function(e){
    e.preventDefault();
    var data = $(this).serializeArray();
    editContact(data);
  });

  //show the form on the click of delete button
  $(document).on('click','#delete-contact',function(){
    var id = $(this).closest('tr').data('id');
    getContact(id,'delete');
  });

  // ----------------------------
  // ------CRUD Functions------
  // ----------------------------

  //get contacts
  function getContacts(){
    $.get('/contacts', function (data){
        //loop through the data and populate all the contacts
        data.forEach(function(contact){
          $('.contacts-list').append(contactListHtml(contact));
        });
    });
  }

  //post form data
  function newContact(data){
      json = {};
      data.forEach(function(item){
        json[item.name]=item.value;
      });
      $.post('/contact/new',json,function(data){
        wipeContactsTable();
        getContacts();
        showForm();
      },'json');
  }

  //post form data
  function editContact(data){
      json = {};
      data.forEach(function(item){
        json[item.name]=item.value;
      });
      $.put('/contact/new',json,function(data){
        wipeContactsTable();
        getContacts();
        showForm();
      },'json');
  }

  //get contact
  function getContact(id,type){
    $.ajax({
      dataType: "json",
      url: '/contact/'+id,
      success: function(data,status,jq) {
        console.log('Data:',data);

          //functionality for show,edit,delete
          switch (type) {
            case 'show':
              $.when(showForm(data)).done(function(){
                $('.contact-submit').remove();
              });
              break;
            case 'edit':
              $.when(showForm(data)).done(function(){
                $('form.new_contact').removeClass('new_contact');
                $('form').addClass('edit_contact');
              });
              break;
            case 'delete':
              $.when(showForm(data)).done(function(){
                $('.contact-submit').remove();
              });
              break;
            default:
          }
      }
    });
  }

  // ----------------------------
  // ------Layout Functions------
  // ----------------------------

  //clean the contacts table
  function wipeContactsTable(){
    var childrenCount = $('.contacts-list').children().length;
    for(var i=0;i<childrenCount;i++){
      $('.contacts-list').children()[i].remove();
    }
  }

  //write contact to form inputs
  function contactHtml(){

  }

  //write contact html from contact-table-template
  function contactListHtml(json){
    var source   = $("#contact-table-template").html();
    var template = Handlebars.compile(source);
    var context = json;
    return template(context);
  }

  //write form html from form-template
  function contactFormHtml(json){
    var source   = $("#form-template").html();
    var template = Handlebars.compile(source);
    var context = json;
    return template(context);
  }

  function showForm(json){
    if ($('#contact-form').is(':visible')) {
      $('.form-container').remove();
    }else {
      $('#contact-form').append(contactFormHtml(json));
    }
    $('#contact-form').toggle();
  }

});

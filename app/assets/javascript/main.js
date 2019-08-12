import copyToClipBoard from "../../javascript/copyToClipboard";
$(document).on('turbolinks:load', function () {
  $('.datepicker').datepicker({
    format: 'mm/dd/yyyy',
  });

  $('#dob').change(function () {
    $('div.notice').html('')
  });

  $('#dob-btn').click(function () {
    let dob = $('#dob').val();

    if (dob) {
      const date = new Date(dob);
      const month = date.toLocaleString('default', { month: 'long' });
      dob = ('00' + date.getDate()).slice(-2) + '-' + month + '-' + date.getFullYear();
      $('#martiandate-form').attr('action', "/martian-birthday-on-" + dob).submit()
    } else {
      notice('Please enter your birthdate')
    }
  });

  $('#nameInput').keyup(function () {
    $('div.notice').html('')
  });

  $('.share-btn').click(function () {
    let name = $('#nameInput').val();
    if (name) {
      name = name.split(' ').join('-');
      const shareMedia = $(this).data('share-media');
      const data = window.location.hostname + '/' + name + '-' + window.location.pathname.slice(1);
      share(shareMedia, data);
    } else {
      notice('Please Enter Name')
    }
  });

  function notice(msg) {
    $('div.notice').html('<span>' + msg + '</span>')
  }

  function share(shareMedia, data) {
    switch (shareMedia) {
      case 'facebook':
        shareOnFacebook(data);
        break;
      case 'twiter':
        shareOnTwiter(data);
        break;
      case 'copyToClipboard':
        copyToClipBoard(data);
        notice('Link Copied');
        break;
    }
  }

  function shareOnFacebook(data) {
    window.open('https://www.facebook.com/sharer/sharer.php?u=' + data)
  }

  function shareOnTwiter(data) {
    window.open('https://twitter.com/intent/tweet?text=' + data)
  }

  if($(".toggle .toggle-title").hasClass('active') ){
    $(".toggle .toggle-title.active").closest('.toggle').find('.toggle-inner').show();
  }

  $(".toggle .toggle-title").on('click', (event) => {
    if($(event.currentTarget).hasClass('active')) {
      $(event.currentTarget).removeClass("active").closest('.toggle').find('.toggle-inner').slideUp(200);
    } else{
      $(event.currentTarget).addClass("active").closest('.toggle').find('.toggle-inner').slideDown(200);
    }
  });
});

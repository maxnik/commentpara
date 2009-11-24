var busy_icon = '<img id="busy" src="/images/busy.gif" />';
var cookie_options = {path: '/', expires: 365};

$(document).ready(function () {

  $('body').bind('ajaxSend', function (elm, xhr, s) {
    if (s.type == 'GET') return;
    if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + "="))) return;
    if (s.data) {
      s.data = s.data + "&";
    } else {
      s.data = "";
      // if there was no data, jQuery didn't set the content-type
      xhr.setRequestHeader("Content-Type", s.contentType);
    }
    s.data = s.data + encodeURIComponent(window._auth_token_name)
		    + "=" + encodeURIComponent(window._auth_token);
  });
		    
  $('input#preview').click(function () {
    var $preview_button = $(this);
    var $form = $preview_button.parent();
    $.ajax({
      beforeSend: function (XMLHttpRequest) {
	$('#busy').remove();
	$form.append(busy_icon);
      },
      complete: function (XMLHttpRequest, textStatus) {
	$('#busy').remove();
      },
      type: 'POST',
      url: '/preview',
      data: $form.serialize(),
      dataType: 'script'
    });
    return false;
  });

  $('input#submit-comment').live('click', function () {
    var $submit_button = $(this);
    var $form = $submit_button.closest('form');

    if ($('#remember-you', $form).attr('checked')) {
      $.cookie('author', $('input#comment_author', $form).val(), cookie_options);
      $.cookie('url', $('input#comment_url', $form).val(), cookie_options);
    }
				   
    $('.error', $form).html('');

    $.ajax({
      beforeSend: function (XMLHttpRequest) {
	$('#busy').remove();
	$submit_button.after(busy_icon);
      },
      complete: function (XMLHttpRequest, textStatus) {
	$('#busy').remove();
      },
      type: 'POST',
      url: $form.attr('action'),
      data: $form.serialize(),
      dataType: 'script'
    });
    return false;
  });
		    
  $('a.comment-link').live('click', function () {
    var $clicked_link = $(this);
    var $comments_zone = $clicked_link.parent().next('div.comments-zone');
    if ($comments_zone.html() == '') {
      $.ajax({
	clickedLink: $clicked_link,
	beforeSend: function (XMLHttpRequest) {
	  this.clickedLink.replaceWith(busy_icon);
	},
	complete: function (XMLHttpRequest, textStatus) {
	  this.clickedLink.replaceAll('#busy');
	},
	type: 'GET',
	url: $clicked_link.attr('href'),
	dataType: 'script'
      });      
    } else if ($comments_zone.css('display') == 'none')  {
      $comments_zone.show();
    } else {
      $comments_zone.hide();
    }
    return false;
  });
		    
  $('.comments-zone .pagination a').live('click', function () {
    var $clicked_link = $(this);

    $.ajax({
      clickedLink: $clicked_link,
      beforeSend: function (XMLHttpRequest) {
	this.clickedLink.replaceWith(busy_icon);
      },
      complete: function (XMLHttpRequest, textStatus) {
	this.clickedLink.replaceAll('#busy');
      },
      type: 'GET',
      url: $clicked_link.attr('href'),
      dataType: 'script'
    });
    return false;
  });
		    
  $('a.delete').live('click', function () {
    if (!this.title || confirm(this.title)) {
      var $clicked_link = $(this);
      
      $.ajax({
	clickedLink: $clicked_link,
	beforeSend: function (XMLHttpRequest) {
	  this.clickedLink.replaceWith(busy_icon);
	},
	complete: function (XMLHttpRequest, textStatus) {
	  this.clickedLink.replaceAll('#busy');
	},
	type: 'POST',
	url: $clicked_link.attr('href'),
	data: '_method=delete',
	dataType: 'script'
      });
    }
    return false;
  }).attr('rel', 'nofollow');
});

function replace_elements(elems)
{
  for (var id in elems) {
    $('#'+id).html(elems[id]);
  } 
}

function fill_comment_form(elems)
{
  replace_elements(elems);
  for (var comment_zone_id in elems) {
    $('#' + comment_zone_id + ' input#comment_author').val($.cookie('author'));
    $('#' + comment_zone_id + ' input#comment_url').val($.cookie('url'));
  }
}

function hide_comment_form(elems)
{
  for (var id in elems) {
    $('#'+id).hide();
  }
}

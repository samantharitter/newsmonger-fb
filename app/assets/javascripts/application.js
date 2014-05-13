// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap

$(document).ready(function() {
    // handle replies to comments
    $('.reply-to-comment').click(function (e) {
        var commentId = $(this).attr("comment-id");
        var storyId = $(this).attr("story-id");

        var form = '<form accept-charset="UTF-8" action="/comments/new" method="get">';
        form += '<div style="margin:0;padding:0;display:inline">';
        form += '<input name="utf8" type="hidden" value="&#x2713;" /></div>';
        form += '<textarea cols="60" id="body" name="body" rows="3"></textarea><br/>';
        form += '<input id="comment_id" name="parent_id" type="hidden" value="' + commentId + '" />'
        form += '<input id="story_id" name="story_id" type="hidden" value="' + storyId + '" />';
        form += '<br/><input class="btn btn-primary" name="commit" type="submit" value="Reply" /></form><br/>';

        $('#reply-form-' + commentId).html(form);
        $(this).html("");
    });
});

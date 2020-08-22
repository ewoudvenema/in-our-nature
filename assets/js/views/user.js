import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();
    $('#password').password({
      shortPass: 'The password is too short',
      badPass: 'Weak; try combining letters & numbers',
      goodPass: 'Medium; try using special charecters',
      strongPass: 'Strong password',
      containsUsername: 'The password contains the username',
      enterPass: 'Type your password',
      showPercent: false,
      showText: true, // shows the text tips
      animate: true, // whether or not to animate the progress bar on input blur/focus
      animateSpeed: 'fast', // the above animation speed
      username: false, // select the username field (selector or jQuery instance) for better password checks
      usernamePartialMatch: true, // whether to check for username partials
      minimumLength: 8 // minimum password length (below this threshold, the score is 0)
    }).on('password.score', function (e, score) {
      if (score > 65) {
        $('#submit').removeAttr('disabled');
      } else {
        $('#submit').attr('disabled', true);
      }
    });
    $('#confirmPassword, #password').on('input', function(){
      var password = $('#password').val();
      var confirmPassword = $('#confirmPassword').val();
      var borderColor = $('button').css('border-color');

      if(password === confirmPassword){
        $('button').prop('disabled', false);
        $('#confirmPassword').css('border-color', '');
      }
      else{
        $('button').prop('disabled', true);
        $('#confirmPassword').css('border-color', 'red');
      }
    });
    $(window).on('load ', function(){
      var navbar = $('#nav-bar-header').height();
      var footer = $('.footer').height();
      var login = $('#login').height();

      var viewport = $(window).height();

      var fill = viewport - navbar - footer - login - 50;
      fill = fill + 'px';

      $('.fill-bottom').css('height', fill);
    });
    $(function(){
      var display = $(".ui.negative.message").css('display');
      var mobile = $('#nav-bar-header').css('display');

      if(display !== "none"){
        var element = $(".ui.negative.message");

        if($('#nav-bar-header').css('display') != 'none'){
          $(element).addClass("five wide column centered");
        }
        else {
          $(element).addClass("sixteen wide column centered");
        }
        $(element).css("margin-bottom", '15px');
        $(element).insertBefore("h2");
      }
    });
    $(".ui.dividing.header").click(function(){
      $("form:visible").hide();
      $(".tohide:visible").hide();
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
    });
    $(".general-information").click(function(){
      $(".general-info-form").show();
    });
    $(".general-information-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".general-info-form-mobile").toggle();
    });
    $(".change-password").click(function(){
      $(".change-password-form").show();
    });
    $(".change-password-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".change-password-form-mobile").toggle();
    });
    $(".my-projects").click(function(){
      $(".my-projects-row").show();
    });
    $(".my-projects-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".my-projects-row-mobile").toggle();
    });
    $(".my-communities").click(function(){
      $(".my-communities-row").show();
    });
    $(".community-invitations").click(function(){
      $(".community-invitations-row").show();
    });
    $(".my-communities-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".my-communities-row-mobile").toggle();
    });
    $(".followed-communities").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".followed-communities-row").show();
    });
    $(".followed-communities-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".followed-communities-row-mobile").toggle();
    });
    $(".change-photo").click(function(){
      $(".change-photo-form").show();
    });
    $(".change-photo-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $(".change-photo-form-mobile").toggle();
    });
    $('.follow-button').on('click', followButtonAction);

    $(".delete-account").click(function(){
      $("#delete-account-modal").modal('show');
    });

    /* Community invitation */
    $('.accept-invite-button').on('click', acceptInvitationButtonAction);
    $('.reject-invite-button').on('click', rejectInvitationButtonAction);

    $("#community-invitations-mobile").click(function(){
      $(".selected-header").removeClass("selected-header");
      $(this).addClass("selected-header");
      $("#community-invitations-row-mobile").toggle();
    });

    let invitationModal = $("#community-invitation-modal");
    invitationModal.modal('attach events', '#invitation-modal-cancel', 'hide');
    /* Community invitation end */

    function followButtonAction(e) {
      e.preventDefault();
      let communityId = parseInt($(this).val());
      let  csrf = $("meta[name=\"csrf\"]").attr("content");
      $.ajax({
        type: 'POST',
        url: '/api/v1/user/follow_community/toggle_follow/' + communityId,
        "headers": {
          "X-CSRF-TOKEN": csrf
        },
        success: function(data) {
          if(data.follows) {
            $(".follow-button[value="+communityId +"]").text("Unfollow");
            $(".follow-button[value="+communityId +"]").removeClass("positive");
          } else{
            $(".follow-button[value="+communityId +"]").text("Follow");
            $(".follow-button[value="+communityId +"]").addClass("positive");
          }
          $("meta[name=\"csrf\"]").attr("content", data.csrf)
        }
      })
    }

    function acceptInvitationButtonAction(e){
      e.preventDefault();
      let communityId = parseInt($(this).val());
      let  csrf = $("meta[name=\"csrf\"]").attr("content");
      $.ajax({
        type: 'POST',
        url: '/api/v1/user/follow_community/accept_invitation/' + communityId,
        "headers": {
          "X-CSRF-TOKEN": csrf
        },
        success: function(data) {
          if(data.follows) {      // All is well
            /* Remove the buttons and replace them with options to visit the community */
            $(".accept-invite-button[value="+communityId+"]").replaceWith('<a href="/community/'+communityId+'"><div class="ui button">Visit community</div></a>')
            $(".reject-invite-button[value="+communityId+"]").replaceWith('<i class="ui big remove icon remove-invite"></i>');
            $('.remove-invite').on('click', function() { removeInviteEntry(this); });
          } else{
            /* Display an error message  TODO */
          }
          $("meta[name=\"csrf\"]").attr("content", data.csrf)
        }
      });
    }

    function rejectInvitationButtonAction(e){
      let communityId = parseInt($(this).val());
      invitationModal.modal('show');
      invitationModal.find(".reject-invitation-confirm").on('click', function(e){
        e.preventDefault();
        rejectInvitation(communityId);
        invitationModal.modal('hide');
      })
    }

    function rejectInvitation(communityId){
      let  csrf = $("meta[name=\"csrf\"]").attr("content");
      $.ajax({
        type: 'POST',
        url: '/api/v1/user/follow_community/reject_invitation/' + communityId,
        "headers": {
          "X-CSRF-TOKEN": csrf
        },
        success: function(data) {
          if(data.success) {      // All is well
            /* Remove the buttons and replace them with options to visit the community */
            $(".accept-invite-button[value="+communityId+"]").remove();
            $(".reject-invite-button[value="+communityId+"]").replaceWith('<i class="ui big remove icon remove-invite"></i>');
            $('.remove-invite').on('click', function() { removeInviteEntry(this); });
          } else{
            /* Display an error message  TODO */
          }
          $("meta[name=\"csrf\"]").attr("content", data.csrf)
        }
      });
    }

    function removeInviteEntry(invokingElement){
      $(invokingElement).parents(".community-invitations-row").remove();
    }
    this.userId = $('#user-id').val();
    $('.delete-account-button').on('click', this.deleteUser.bind(this));
  }
  unmount() {
    super.unmount();
  }

  deleteUser() {
    var settingsLogout = {
      "url": this.baseUrl + "/user/logout",
      "method": "POST",
      "headers": {
        "X-CSRF-TOKEN": this.csrf
      }
    }
    var settings = {
      "url": this.baseUrl + "/api/v1/user/"+this.userId+"/deleted/true",
      "method": "PUT",
      "headers": {
        "X-CSRF-TOKEN": this.csrf
      },
      "success": function(){
        $.ajax(settingsLogout).done(function (response) {
          location.href =  window.location.protocol + "//" + window.location.host
        });
      }
    }
    $.ajax(settings).done(function (response) {
    });
  }


}

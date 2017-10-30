$(document).ready(function() {
  $('.parallax').parallax();
  $('.button-collapse').sideNav();
  $('.dropdown-button').dropdown();
  $('#avatar-change-button').on('click', function(){
    $('#user_avatar').click();
  });
  $(function() {
    function readURL(input) {
      if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
          $('#avatar-preview').attr('src', e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
      }
    }

    $("#user_avatar").change(function(){
      var size_in_megabytes = this.files[0].size/1024/1024;
      if (size_in_megabytes > 2) {
        alert(I18n.t('user.edit_view.avatar_error_js', {size: 2}));
      } else {
        readURL(this);
      }
    });
  });
})

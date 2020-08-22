export default class MainView {
  mount() {
    // This will be executed when the document loads...
    this.baseUrl = window.location.protocol + "//" + window.location.host;

    this.csrf = document.querySelector("meta[name=csrf]").content;


    $("#toggle").click(function () {
      $(this).toggleClass("on");
      $("#menu-mobile").slideToggle();
    });

    $("#menu-mobile .accordion").accordion();

    $(".item-language").click(function () {
      $(this).toggleClass("on");
      $(".available-languages").slideToggle();
    });

    $('.message .close')
      .on('click', function () {
        $(this)
          .closest('.message')
          .transition('fade');
      });

    $("#user-communities").dropdown();
    $("#explore-dropdown-menu").dropdown();

    $('#name-project').keypress(function (e) {
      if (e.which == 13) {

        let csrf = $("meta[name=\"csrf\"]").attr("content");
        let order = "";
        let name = $("#name-project").val();
        window.location = "/explore?name="+name;                  
        }
    });
    $("#user-dropdown").dropdown();
  }


  unmount() {
    // This will be executed when the document unloads...

  }
}

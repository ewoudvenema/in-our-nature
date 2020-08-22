import MainView from './main';

export default class View extends MainView {
  mount() {
    super.mount();
    $(window).on('load ', function(){
      var navbar = $('#nav-bar-header').height();
      var footer = $('.footer').height();
      var page = $('.page-not-found').height();

      var viewport = $(window).height();

      var fill = viewport - navbar - footer + 50;
      fill = fill + 'px';

      $('.page-not-found').css('height', fill);
    });

  }

  unmount() {
    super.unmount();
  }
}

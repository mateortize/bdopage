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
//= require bootsy
//= require bootstrap
//= require_tree .
//= require masonry.pkgd.min
//= require owl.carousel

$(document).ready(function() {
    //Masonry
    if ($(document).width() > 980) {
        var container = document.querySelector('.post-container');
        var msnry = new Masonry( container, {
            itemSelector: '.post'
        });
    }

    $('iframe').load(function(){
      console.log(111);
      $(this).find('html').css({background: 'none'});
    });

    $("#post-carousel").owlCarousel();
})
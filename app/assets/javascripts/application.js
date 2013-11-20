//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require turbolinks
//= require bootstrap.min
//= require forma
$(function() {
  $('.datepicker').datepicker({ dateFormat: 'dd-M-yy', changeMonth: true, changeYear: true, yearRange: "-100:+0" });
});
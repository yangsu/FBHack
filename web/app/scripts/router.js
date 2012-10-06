define([
  // Application.
  'app'
],

function(app) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      '': 'index',
      'room': 'room'
    },

    index: function () {
    },
    room: function () {

    }
  });

  return Router;

});

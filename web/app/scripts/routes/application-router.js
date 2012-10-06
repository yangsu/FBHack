FBHack.Routers.ApplicationRouter = Backbone.Router.extend({
  routes: {
    '': 'index',
    'init': 'index',
    'room/:id': 'room'
  },
  initialize: function () {

  },
  index: function() {
    FBHack.Collections.StreamCollection.fromImgurAPI(function (stream) {
      var view = new FBHack.Views.StreamView({
	model: stream
      });
      view.render();
    });
  },
  room: function(id) {
    FBHack.Collections.StreamCollection.fromOwnAPI(id, function (stream) {
      var view = new FBHack.Views.StreamView({
	model: stream
      });
      view.render();
    });
  }
});

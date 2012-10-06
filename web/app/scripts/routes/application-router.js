FBHack.Routers.ApplicationRouter = Backbone.Router.extend({
  routes: {
    '': 'index',
    'init': 'index',
    'room/:id': 'room'
  },
  initialize: function () {
    var self = this,
      width = 0;
    $('#main').scroll(_.throttle(function (e) {
      var pos = $(e.target).scrollLeft();
      if (!width) {
	width = self.view.$el.width();
      }
      console.log((self.view.model.maxPos - pos/width * 100));
      if ((self.view.model.maxPos - pos/width * 100) <= 250) {
        self.view.fetchNext();
      }
    }, 50));
  },
  index: function() {
    var self = this;
    FBHack.Collections.StreamCollection.fromImgurAPI(function (stream) {
      self.view = new FBHack.Views.StreamView({
        model: stream
      });
      self.view.render();
    });
  },
  room: function(id) {
    var self = this;
    FBHack.Collections.StreamCollection.fromOwnAPI(id, function (stream) {
      self.view = new FBHack.Views.StreamView({
        model: stream
      });
      self.view.render();
    });
  }
});

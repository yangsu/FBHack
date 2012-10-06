FBHack.Views.StreamView = Backbone.View.extend({
  el: '#stream',
  template: FBHack.getTemplate('stream'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {

  },
  events: {
    'keydown': 'onKeyDown'
  },
  onKeyDown: function (e) {
    console.log('test');
    var inc = 0;
    if (e.keyCode === 37) { // left
      inc = -800;
    } else if (e.keyCode === 39) { // right
      inc = 800;
    }
    $('#stream_container').css('margin-left', inc + 'px');
  },
  render: function () {
    this.$el.html(this.template({
      images: this.model.computeLayout(this.$el.width(), this.$el.height()).toJSON()
    }));
  }
});

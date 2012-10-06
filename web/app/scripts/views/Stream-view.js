FBHack.Views.StreamView = Backbone.View.extend({
  el: '#stream',
  template: FBHack.getTemplate('stream'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {
    this.model.on('add', this.render, this);
  },
  events: {
    'keydown': 'onKeyDown'
  },
  onKeyDown: function (e) {
    var inc = 0;
    if (e.keyCode === 37) { // left
      inc = -800;
    } else if (e.keyCode === 39) { // right
      inc = 800;
    }
    $('#stream, #stream_container').animate({
      'margin-left': inc + 'px'
    }, 2000);
    e.preventDefault();
    e.stopPropagation();
  },
  fetchNext: function () {
    this.model.fetchNext();
  },
  renderAdditional: function (newModels) {
    // this.model.computeLayout(this.$el.width(), this.$el.height());
    // this.$el.find('#stream_container').append(this.template({
    //   images: newModels.toJSON()
    // }));
  },
  render: function () {
    this.$el.find('#stream_container').html(this.template({
      images: this.model.computeLayout(this.$el.width(), this.$el.height()).toJSON()
    }));
  }
});

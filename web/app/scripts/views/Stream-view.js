FBHack.Views.StreamView = Backbone.View.extend({
  el: '#stream',
  template: FBHack.getTemplate('stream'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {
    this.model.on('add', this.render, this);
  },
  events: {
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

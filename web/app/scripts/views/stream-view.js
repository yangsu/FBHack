FBHack.Views.StreamView = Backbone.View.extend({
  el: '#stream',
  template: FBHack.getTemplate('stream'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {

  },
  render: function () {
    this.$el.html(this.template({
      images: this.model.toJSON()
    }));
  }

});

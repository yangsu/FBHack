FBHack.Views.StreamView = Backbone.View.extend({
  el: '#main',
  template: FBHack.getTemplate('stream'),
  qrTemplate: FBHack.getTemplate('qr'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {
    this.model.on('add', this.render, this);
  },
  events: {
    'click #qrlink': 'showQR'
  },
  showQR: function (e) {
    $('#qr')
      .find('.content')
      .html(this.qrTemplate({ id : this.model.get('id') }))
      .end()
    .show('slow');
    e.preventDefault();
  },
  fetchNext: function () {
    this.model.fetchNext();
  },
  render: function () {
    this.$el.find('#stream_container').html(this.template({
      images: this.model.computeLayout(this.$el.width(), this.$el.height()).toJSON()
    }));
  }
});

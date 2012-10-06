FBHack.Views.StreamView = Backbone.View.extend({
  el: '#main',
  template: FBHack.getTemplate('stream'),
  qrTemplate: FBHack.getTemplate('qr'),
  model: FBHack.Collections.StreamCollection,
  initialize: function () {
    this.model.on('add', this.render, this);
  },
  events: {
    'click #qrlink': 'showQR',
    'click #qrlink .x': 'hideQR'
  },
  showQR: function (e) {
    $('#qr')
      .find('.content')
      .html(this.qrTemplate({ id : this.id }))
      .end()
    .show('slow');
    e.preventDefault();
  },
  hideQR: function (e) {
    $('#qr').hide('slow');
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

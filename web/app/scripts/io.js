var socket = io.connect();
socket.on('new_content', function (data) {
  FBHack.router.view.model.add({ src: data.payload.link }).trigger('change');
  var offset = FBHack.router.view.$el.find('.box:last-child').width()
              + FBHack.router.view.$el.find('.box:last-child').offset().left;
  $('#stream, #stream_container').css({
    'margin-left': -offset + 'px'
  });
});

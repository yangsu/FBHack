var socket = io.connect();
socket.on('new_content', function (data) {
  FBHack.router.view.model.add({ src: data.payload.link }).trigger('change');
  $('#stream, #stream_container').css({
    'margin-left': (FBHack.router.view.maxPos - 200) + 'px'
  });
});

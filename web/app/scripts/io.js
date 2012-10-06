var socket = io.connect('http://localhost:8080');
socket.on('new_content', function (data) {
  console.log(data);
  socket.emit('my other event', { my: 'data' });
});
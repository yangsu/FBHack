var socket = io.connect();
console.log(socket);
//socket.join('a_TT-Ki-Ji_');
socket.on('new_content', function (data) {
  console.log(data);
  socket.emit('my other event', { my: 'data' });
});

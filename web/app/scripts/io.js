var socket = io.connect();
socket.on('new_content', function (data) {
  console.log(data);
});

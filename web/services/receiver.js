function pushContent(aid, content, res) {
  var cid = Model.Content.create(content);
  Model.Album.enqueue(aid, cid, function (err) {
    if (err) {
      res.send(sc.BAD_REQUEST);
      return;
    }
    io.sockets.clients(aid).forEach(function (socket) {
      console.log(socket);
      socket.emit('new_content',
      {
        album: aid,
        cid: cid,
        payload: content
      });
    });
    // send http response
    res.send(sc.CREATED);
  });
}

module.exports = {
  validateEvent: function (event) {
    var typesAreValid = _.isObject(event) &&
      _.has(event, 'type') &&
      _.isString(event.type) &&
      _.has(event, 'payload') &&
      _.isObject(event.payload);

    if (typesAreValid) {
      return true;
    }
    return false;
  },

  handleEvent: function (event, res) {
    switch (event.type) {

    case "PUSH_PHOTO":
      var aid = event.aid
        , payload = event.payload;
      if (payload.link && _.isString(payload.link)) {
        pushContent(aid, payload, res);
      } else {
        res.send(sc.BAD_REQUEST, 'Must include link to content.');
        return;
      }
      break;

    default:
      res.send(sc.INTERNAL_SERVER_ERROR, 'Could not determine event type.');
      break;

    }
  }
}

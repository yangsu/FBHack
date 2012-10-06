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
    case "PUSH_CONTENT":
      var aid = event.aid
        , payload = event.payload;
      if (payload.link && _.isString(payload.link)) {
        Model.Album.pushContent(aid, payload, res);
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

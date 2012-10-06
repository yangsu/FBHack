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
      Model.Album.pushContent(aid, payload, res);
      break;
    default:
      res.send(sc.INTERNAL_SERVER_ERROR);
      break;
    }
  }
}

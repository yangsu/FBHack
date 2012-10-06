module.exports = {
  validateEvent: function (event) {
    var typesAreValid = _.isObject(event) &&
      _.has(event, 'type') &&
      _.isString(event.type) &&
      _.has(event, 'payload') &&
      _.isObject(event.payload);

    // TODO: validate contents of payload
    if (typesAreValid) {
      return true;
    }
    return false;
  },

  handleEvent: function (event) {
    // TODO: implement me
    return true;
  }
}

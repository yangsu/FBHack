var prefix = "a_"
  , default_name = "New Album";
exports.Album = {
  create: function (name, meta) {
    var shortid = require('shortid');
    var aid = prefix + shortid.generate();
    // TODO: check for aid collisions?
    redis.set(aid, JSON.stringify({
      name: name || default_name,
      metadata: meta,
      users: [],
      queue: []
    }));
    return aid;
  },

  pushContent: function (aid, content) {
  }
}

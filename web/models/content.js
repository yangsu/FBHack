var shortid = require('shortid');

var prefix = "c_";

function generateCID () {
  return prefix + shortid.generate();
}

exports.Content = {
  getPrefix: function () { return prefix; },

  create: function (content) {
    var cid = generateCID();
    // TODO: verify content payload
    redis.set(cid, JSON.stringify(content));
    return cid;
  }
};

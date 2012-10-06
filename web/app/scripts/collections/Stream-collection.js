FBHack.Collections.StreamCollection = Backbone.Collection.extend({
  model: FBHack.Models.ItemModel,
  initialize: function () {

  },
  dimensions: [25, 30, 40, 50, 60, 70, 75, 100],
  computeLayout: function (width, height) {
      var left, left1 = 0, left2 = 0, top;
      var i, w, h;
      var lastTopH = 0, lastBotH = 0;
      var lastTopW = 0, lastBotW = 0;
      for (i = 0; i < this.length; i++) {
	  w = this.dimensions[Math.floor(Math.random()*8)];
	  if (left1 > left2) {
	      left = left2;
	      left2 += w/100 * width;
	      top = lastTopH/100 * height;
	      h = 100 - lastTopH;
	      lastBotH = h;
	      lastBotW = w;
	  } else if (left2 > left1) {
	      left = left1;
	      left1 += w/100 * width;
	      top = 0;
	      h = 100 - lastBotH;
	      lastTopH = h;
	      lastTopW = w;
	  } else {
	      left = left1;
	      left1 += w/100 * width;
	      top = 0;
	      h = this.dimensions[Math.floor(Math.random()*8)];
	      lastTopH = h;
	      lastTopW = w;
	  }
	  var vals = {
	    w: w,
	    h: h,
	    left: left,
	    top: top
	  };
	  this.at(i).set(vals);
	}
    return this;
  }
});

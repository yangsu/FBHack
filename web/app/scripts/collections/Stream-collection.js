FBHack.Collections.StreamCollection = Backbone.Collection.extend({
  model: FBHack.Models.ItemModel,
  initialize: function () {

  },
  // dimensions: [25, 30, 40, 50, 60, 70, 75, 100],
  dimensions: [30, 40, 50, 60, 70, 100],
  getRandomDimension: function () {
    return this.dimensions[Math.floor(Math.random()*this.dimensions.length)]
  },
  computeLayout: function (width, height) {
      var i, w, h, left, top,
	left1 = 0, left2 = 0,
	lastTopH = 0, lastBotH = 0,
	lastTopW = 0, lastBotW = 0,
	diff = 0;
      for (i = 0; i < this.length; i++) {
	  w = this.getRandomDimension();
	  if (left1 > left2) {
	      left = left2;
	      diff = Math.floor((left1 - left2)/width * 100);
	      if (Math.random() >= 0.5 && diff >= 25 && _.contains(this.dimensions, diff)) {
		w = diff;
		left2 = left1;
	      } else {
		left2 += w/100 * width;
	      }
	      top = lastTopH/100 * height;
	      h = 100 - lastTopH;
	      lastBotH = h;
	      lastBotW = w;
	  } else if (left2 > left1) {
	      left = left1;
	      diff = Math.floor((left2 - left1)/width * 100);
	      if (Math.random() >= 0.5 && diff >= 25 && _.contains(this.dimensions, diff)) {
		w = diff;
		left1 = left2;
	      } else {
		left1 += w/100 * width;
	      }
	      top = 0;
	      h = 100 - lastBotH;
	      lastTopH = h;
	      lastTopW = w;
	  } else {
	      left = left1;
	      left1 += w/100 * width;
	      top = 0;
	      h = this.getRandomDimension();
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

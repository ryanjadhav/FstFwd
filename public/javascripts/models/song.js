var Song = Backbone.Model.extend({
	url : function() {
      var base = 'song';
      if (this.isNew()) return base+'/create';
      return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
	}
});
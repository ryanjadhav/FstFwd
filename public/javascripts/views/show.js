App.Views.Show = Backbone.View.extend({
	initialize: function(){
		this.song = this.options.song;
		this.render();
	},
	
	render: function(){
		var out = '';
		if(this.song.length > 0){
			out += '<h3>Found a song!</h3>'; 
		} else {
			out += '<h3>No Songs!</h3>'; 
		}
		
		$(this.el).html(out);
		$('.contents').html(this.el);
	}
});
App.Controllers.Songs = Backbone.Controller.extend({
	routes: {
		"s/:id":	"show",
		"":	"newSong"
	},
	
	show: function(id){	
		$.getJSON('/song/show/' + id, function(data) {
	    if(data) {
	    	console.log(data);
	    } else {
	    	console.log('invalid id');
	    	window.location.hash = '#';
	    }
    });
	},
	
	newSong: function(){
		console.log('Controller routes to newsong');
		
		new App.Views.NewSong({ model: new Song() });
	}
});
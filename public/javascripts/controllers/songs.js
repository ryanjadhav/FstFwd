App.Controllers.Songs = Backbone.Controller.extend({
	routes: {
		"":	"newSong",
		"/:id":	"show"
	},
	
	show: function(id){
		console.log('Controller routes to id');
		var song = new Song({ id: id });
		console.log(song);
		song.fetch({
			success: function(model, resp){
				console.log('found a song');
				new App.Views.Show({ model: song });
			},
			error: function(){
				console.log('error fetching song');
				new Error({ message: 'Could not find song'});
			}
		});
	},
	
	newSong: function(){
		console.log('Controller routes to newsong');
		new App.Views.NewSong();
	}
});
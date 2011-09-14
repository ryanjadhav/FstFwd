App.Controllers.Songs = Backbone.Controller.extend({
	routes: {
		"/:id":	"show",
		"": "newSong"
	},
	
	show: function(id){
		var song = new Song({ id: id });
		song.fetch({
			success: function(model, resp){
				new App.Views.Show({ model: song });
			},
			error: function(){
				new Error({ message: 'Could not find song'});
			}
		});
	},
	
	newSong: function(){
		new App.Views.NewSong();
	}
});
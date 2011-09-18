App.Views.NewSong = Backbone.View.extend({
	events: {
		"submit form" : "save"
	},
	
	className: "url_input_holder",
	
	initialize: function(){
		console.log('Init NewSong');
		this.render();
	},
	
	save: function(){
		var self = this;
		var msg = 'Successfully created!';
		
		console.log('saved!!');
		
		console.log(this);
		
		this.model.save({ orig_url: this.$('.url_input').val() }, {
			success: function(model, resp){
				//new App.Views.Notice({ message: msg});
				
				self.model = model;
				self.render();
				self.delegateEvents();

				Backbone.history.saveLocation('s/' + model.id);
			},
			error: function(){
				//new App.Views.Error();
			}
		});
		
		return false;
	},
	
	render: function(){
		
		var out = "<form class='input_url'>";
		out += "<input type='text' class='url_input' placeholder='Song URL'/>";
		out += '<input class="submit_input" type="submit" value="Search">';
		out += "</form>";
				
		$(this.el).html(out);
		$('.contents').append(this.el);
	}
});
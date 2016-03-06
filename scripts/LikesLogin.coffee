class @LikesLogin
	@oauthKey = 'v9UrevHg6LXweUdAjasr06NsdY4'

$ ->
	OAuth.initialize(LikesLogin.oauthKey)
	$("#signin").click ->
		OAuth.popup('tumblr')
			.done (result) -> 
	    		window.location = "/likes";
			.fail (error) ->
				console.log("Login error: " + error);

		
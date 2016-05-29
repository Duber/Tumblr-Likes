$ ->
	$("#signin").click ->
		OAuth.initialize("eUqCWTW-6VpWWcOvj8edJ6aKNUo", {"cache" : true})
		OAuth.popup 'tumblr'
			.done (result) ->
				window.location = "/likes";
			.fail (error) ->
				console.log("Login error: " + error)

		
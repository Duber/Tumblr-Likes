$ ->
	$("#signin").click ->
		OAuth.clearCache();
		OAuth.initialize("v9UrevHg6LXweUdAjasr06NsdY4", {"cache" : true})
		OAuth.popup 'tumblr'
			.done (result) ->
				window.location = "/likes";
			.fail (error) ->
				console.log("Login error: " + error)

		
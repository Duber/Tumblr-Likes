
class Unlike
	@post = (post) ->
		Tumblr.post "https://api.tumblr.com/v2/user/unlike", {"id": post.id, "reblog_key": post.key}
			.done (data) ->
				@id = post.id
				console.log("unliked post #{id}") if @debug
				$("#"+id+" a.remove").remove()
				$("#"+id+" img").remove()
				$("#"+id+" div.overprint").remove()
				$("#"+id+" div.play_overlay").remove()
				$("#"+id+" div.caption").remove()
				$("#"+id).addClass("removed")
			.fail (err) ->
				alert("Sorry, but an error has occurred.")
	;
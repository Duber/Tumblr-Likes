#= require ContentHelper

class Like
	@debug = true
	currentOffset = 0
	processing = false

	@get = (runs) ->
		return if processing
		console.log "getting likes at offset " + currentOffset if @debug
		processing = true

		runs = runs or 1
		next = if runs is 1 then -> else -> Like.get(runs - 1)

		# --- GET /v2/user/likes ---
		Tumblr.get "https://api.tumblr.com/v2/user/likes?offset="+currentOffset
			.done (data) ->
				console.log "200 OK /v2/user/likes" if @debug
				console.log data if @debug
				successForLikes(data)
				currentOffset += 20
				processing = false
				next()
			.fail (err) ->
				console.log err if @debug
				next()

	successForLikes = (data) ->
		# if less than batch size, we must have run out!
		if currentOffset >= data.response.liked_count
			console.log "Reached end of likes" if @debug
			$("#loading").fadeOut 800
		ContentHelper.setContent(data.response.liked_posts)

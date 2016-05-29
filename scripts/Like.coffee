#= require ContentHelper
#= require Header

class Like
	@debug = false

	currentOffset = 0
	isFinished = false

	@get = (runs) ->
		return if isFinished
		runs = runs or 1

		console.log "getting likes at offset " + currentOffset if @debug
		next = if runs is 1 then etc else -> getLikes(runs - 1)

		# --- GET /v2/user/likes ---
		Tumblr.get "https://api.tumblr.com/v2/user/likes?offset="+currentOffset
			.done (data) ->
				console.log "200 OK /v2/user/likes" if @debug
				console.log data
				successForLikes(data)
				next()
			.fail (err) ->
				console.log err if @debug
				next()

		currentOffset += 20
		console.log "finished" if @debug
	;

	successForLikes = (data) ->
		console.log "got data" if @debug

		# if less than batch size, we must have run out!
		if currentOffset >= data.response.liked_count
			console.log "We're finished!" if @debug
			isFinished = true
			$("#loading").fadeOut 800

		ContentHelper.setContent(data.response.liked_posts)
	;

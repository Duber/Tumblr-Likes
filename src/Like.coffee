#= require ContentHelper

class Like
	debug = true
	likedDate = new Date()
	processing = false

	@get = (runs) ->
		return if processing
		console.log "getting likes before  " + likedDate if debug
		processing = true

		runs = runs or 1
		next = if runs is 1 then -> else -> Like.get(runs - 1)

		# --- GET /v2/user/likes ---
		Tumblr.get "https://api.tumblr.com/v2/user/likes?before="+ (likedDate.getTime() / 1000)
			.done (data) ->
				console.log "200 OK /v2/user/likes" if debug
				console.log data if debug
				posts = data.response.liked_posts
				numberOfPosts = data.response.liked_count
				# if less than batch size, we must have run out!
				if posts.length == 0
					console.log "Reached end of likes" if debug
					$("#loading").fadeOut 800
				ContentHelper.RenderPosts(posts)
				lastPost = posts[posts.length - 1]
				likedDate = new Date(lastPost.liked_timestamp * 1000)
				currentState = history.state || {}
				currentState.likedDate = likedDate
				path = getPathFrom(likedDate)
				history.replaceState( currentState, "Tumblr Likes Grid", path)
				processing = false
				next()
			.fail (err) ->
				console.log err if debug
				next()
	getPathFrom = (date) ->
		day = date.getDate()
		month = date.getMonth() + 1
		year = date.getFullYear()
		return intToString(day) + intToString(month) + year
	intToString = (number) ->
		if (number < 10)
			return "0" + number
		return number

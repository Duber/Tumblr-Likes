#= require ContentHelper
#= require Header

class Likes
	@debug = false

	currentOffset = 0
	isScrolling = false
	isFinished = false

	# --- get likes from server  ---

	getLikes = (runs, etc) ->
		return if isFinished
		runs = runs or 1
		etc = etc or ->

		console.log "getting likes at offset " + currentOffset if @debug
		next = if runs is 1 then etc else -> getLikes(runs- 1, etc)

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


	# --- unlike posts ---

	@unlike = (post) ->
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

	# --- infinite scroll ---

	scrollWatch = ->
		win = $(window)
		win.scroll ->
			return if isFinished

			if win.scrollTop() >= $(document).height() - win.height() - 200
				return if isScrolling
				isScrolling = true
				getLikes(2, ->
					isScrolling = false
				)
			;
		;
	;

	@startUp = ->
		console.log "Initialize Oauth.js"
		OAuth.initialize("v9UrevHg6LXweUdAjasr06NsdY4", {"cache" : true})
		window.Tumblr = OAuth.create 'tumblr'
		if (!Tumblr)
			window.location = "/"
		Header.setHeaderInfo()
		ContentHelper.createColumns()
		getLikes(2)
		scrollWatch()
	;

window.Likes = Likes

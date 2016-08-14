#= require Like
#= require Header
#= require ContentHelper

class Program
	@debug = true
	@OAuthKey = "v9UrevHg6LXweUdAjasr06NsdY4"

	@run = ->
		console.log "Initialize Oauth.js" if @debug
		OAuth.initialize(Program.OAuthKey, {"cache" : true})
		window.Tumblr = OAuth.create 'tumblr'
		if (!Tumblr)
			window.location = "."
		Header.setUserInfo()
		beforeDate = getBeforeDateFromUrl()
		Like.get(4, beforeDate)
		infiniteScroll()

	infiniteScroll = ->
		win = $(window)
		win.scroll ->
			if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight)
				Like.get(4)

	getBeforeDateFromUrl = ->
		dateString = location.search.replace('?before=', '')
		dateMillis = Date.parse(dateString)
		if (isNaN(dateMillis))
			return new Date()
		return new Date(dateMillis)

window.Program = Program

#= require Like
#= require Header
#= require ContentHelper

class Program
	@debug = false
	@OAuthKey = "v9UrevHg6LXweUdAjasr06NsdY4"
	isScrolling = false

	@run = ->
		console.log "Initialize Oauth.js"
		OAuth.initialize(Program.OAuthKey, {"cache" : true})
		window.Tumblr = OAuth.create 'tumblr'
		if (!Tumblr)
			window.location = "/"
		Header.setUserInfo()
		ContentHelper.createColumns()
		Like.get(2)
		infiniteScroll()

	infiniteScroll = ->
		win = $(window)
		win.scroll ->
			if win.scrollTop() >= $(document).height() - win.height() - 200
				return if isScrolling
				isScrolling = true
				Like.get(2)

window.Program = Program

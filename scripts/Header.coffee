
class Header
	@setHeaderInfo = () ->
		# --- get user info ---
		Tumblr.get "https://api.tumblr.com/v2/user/info"
			.done (data) ->
				console.log "200 OK /v2/user/info" if @debug
				successForUserInfo(data)
			.fail (err) ->
				console.log err if @debug
	;

	successForUserInfo = (data) ->
		console.log "got user data" if @debug
		console.log data
		setHeaderInfoComplete(data.response.user.likes, data.response.user.name, data.response.user.blogs[0].url)
	;


	setHeaderInfoComplete = (likesCount, userName, primaryUrl) ->
		blog = $("#nav a.blog_title")
		text = "Hello #{userName}"
		blog.attr("href", primaryUrl)
		blog.html(text)
	;
window.Header = Header;
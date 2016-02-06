
class ContentContext
	@setContextForChat = (post, ctx) ->
		ctx.type = "conversation"
		ctx.chat = []
		chat = ctx.chat
		lcv = 0

		while lcv < post.dialogue.length
			if lcv % 2 is 0
				chat[lcv] = {}
				chat[lcv].first = post.dialogue[lcv]
			else
				chat[lcv - 1].second = post.dialogue[lcv]
			++lcv
		;
	;

	@setContextForAnswer = (post, ctx) ->
		ctx.theQuestion = post.question or ""
		ctx.theAnswer = post.answer or ""
		ctx.theAsker = post.asking_name or ""
	;

	@setContextForQuote = (post, ctx) ->
		ctx.text = post.text
		ctx.source = post.source
	;

	@setContextForPhoto = (post, ctx) ->
		ctx.thumbnail = { url: "#" }
		thumbnail = ctx.thumbnail

		if post.photos.length > 0
			sizes = post.photos[0].alt_sizes
			img = if sizes.length-3 < 0 then sizes.length-1 else sizes.length-3
			img = sizes[img]
			thumbnail.url = img.url
			#thumbnail.height = if img.height > MAX_HEIGHT then MAX_HEIGHT else img.height
			#thumbnail.width = if img.width > MAX_WIDTH then MAX_WIDTH else img.width
			thumbnail.height = img.height
			thumbnail.width = img.width
		;
	;

	@setContextForAudio = (post, ctx) ->
		ctx.text = post.caption
		info = ""

		if post.artist and post.artist.length > 0
			if post.track_name and post.track_name.length > 0
				info = "#{post.artist} - #{post.track_name}"
			else
				info = post.artist
		;

		info += "<br/>" + post.album  if post.album and post.album.length > 0
		ctx.info = if info.length > 0 then info else null
		ctx.thumbnail = post.album_art if post.album_art and post.album_art.length > 0
	;

	@setContextForVideo = (post, ctx) ->
		thumbnail = { url: "#" }

		if post.player and post.player.length > 0
			raw = post.player[0].embed_code
			iStart = raw.indexOf("'poster=")
			iEnd = raw.length - 10 # because we know it is towards the end

			# we found some frames
			unless iStart is -1
				frameText = raw.substring(iStart + 8, iEnd - 1)
				frames = frameText.split(",")
				x = 0

				while x < frames.length
					frames[x] = { url: decodeURIComponent(frames[x]) }
					++x

				ctx.frames = frames
			;
		;

		thumbnail.url = post.thumbnail_url
		thumbnail.height = if post.thumbnail_height > MAX_HEIGHT then MAX_HEIGHT else post.thumbnail_height
		thumbnail.width = if post.thumbnail_width > MAX_WIDTH then MAX_WIDTH else post.thumbnail_width
		ctx.thumbnail = thumbnail
	;

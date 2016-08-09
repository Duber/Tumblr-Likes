
class ContentContext
	THUMBNAIL_WIDTH = 250
	useDummyThumbnail = false

	@setContextForPhoto = (post, ctx) ->
		ctx.thumbnail = { url: "#" }
		thumbnail = ctx.thumbnail

		if post.photos.length > 0
			sizes = post.photos[0].alt_sizes
			# img = if sizes.length-3 < 0 then sizes.length-1 else sizes.length-3
			img = sizes[2]
			thumbnail.url = img.url
			thumbnail.height = getScaledHeight(img.height,img.width)
			thumbnail.width = THUMBNAIL_WIDTH
			if useDummyThumbnail
				thumbnail.url = buildDummyThumbnailUrl(thumbnail.height,thumbnail.width)
		;
	;

	@setContextForVideo = (post, ctx) ->
		thumbnail = { url: "#" }

		ctx.code = post.player[0].embed_code
		if useDummyThumbnail
			ctx.code = "<img src='http://dummyimage.com/250x366' height='366' width='250'/>"
	;

	buildDummyThumbnailUrl = (height, width) ->
		return "http://dummyimage.com/" + width + "x" + height
		
	getScaledHeight = (height, width) ->
		return (THUMBNAIL_WIDTH * height / width )

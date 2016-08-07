#=require ContentContext

class ContentHelper
	@debug = true
	templateCache = {}
	templateName = "node"

	@setContent = (posts) ->
		if @debug
			console.log "received posts:"
			console.log posts

		for post in posts
			#templating
			ctx = createContext()

			ctx.id = post.id
			ctx.key = post.reblog_key
			ctx.type = post.type
			ctx.url = post.image_permalink or post.post_url
			ctx.user = post.blog_name

			switch post.type
				when "video"  then ContentContext.setContextForVideo(post, ctx)
				when "photo"  then ContentContext.setContextForPhoto(post, ctx)

			append(renderTemplate(ctx))
		;
	;

	renderTemplate = (data) ->
		template = ""
		# is cached?
		unless templateCache[templateName]
			ctx = {}
			$.ajax
				url: "/assets/templates/#{templateName}.mustache"
				async: false
				context: ctx
				success: (data) ->
					console.log "retrieved template '#{templateName}' from file." if @debug
					ctx.data = data
				failure: ->
					console.log "cold not retrieve template '#{templateName}' from file." if @debug

			if ctx.data
				templateCache[templateName] = ctx.data
				template = ctx.data
		else
			template = templateCache[templateName]

		Mustache.to_html(template, data)
	;

	renderPartial = (partial, render) ->
		partial = trim(render(partial))
		renderTemplate(partial, this)
	;

	createContext = ->
		{
			dynamicPartial: -> renderPartial
		}
	;

	# --- helpers ---

	append = (html) ->
		$grid = $("div.grid")
		$grid.append(html)
		$grid.imagesLoaded().progress( () ->
			$grid.masonry('reloadItems');
			$grid.masonry('layout');
		);
	;

	trim = (string) ->
		string.replace /^\s*|\s*$/g, ""
	;

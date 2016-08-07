#=require ContentContext


class ContentHelper
	@debug = true
	templateCache = {}

	@setContent = (posts) ->
		if @debug
			console.log "received posts:"
			console.log posts
		#posts.sort((a, b) -> b.timestamp - a.timestamp)

		for post in posts
			#templating
			ctx = createContext()

			ctx.id = post.id
			ctx.key = post.reblog_key
			ctx.type = post.type
			ctx.url = post.image_permalink or post.post_url
			ctx.user = post.blog_name
			ctx.noteCount = post.note_count
			ctx.caption = post.caption or ""
			ctx.text = post.body or ""
			ctx.title = post.title or null

			switch post.type
				when "video"  then ContentContext.setContextForVideo(post, ctx)
				when "photo"  then ContentContext.setContextForPhoto(post, ctx)

			# strip html from text
			ctx.text = $("<div>" + ctx.text + "</div>").text()

			# if title is too big, truncate it
			ctx.title = ctx.title.substring(0, 210) if ctx.title and ctx.title.length > 210

			# if text is too big, truncate it
			ctx.text = ctx.text.substring(0, 180) + " [...]" if ctx.text.length > 180
			append(renderTemplate("node", ctx))
		;
	;

	renderTemplate = (name, data) ->
		template = "Could not find template '#{name}'."

		# is cached?
		unless templateCache[name]
			ctx = {}
			$.ajax
				url: "/assets/templates/#{name}.mustache"
				async: false
				context: ctx
				success: (data) ->
					console.log "retrieved template '#{name}' from file." if @debug
					ctx.data = data
				failure: ->
					console.log "cold not retrieve template '#{name}' from file." if @debug

			if ctx.data
				templateCache[name] = ctx.data
				template = ctx.data
		else
			template = templateCache[name]

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

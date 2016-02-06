#=require UQC
#= require ContentContext


class ContentHelper
	COLUMNS = 5
	MAX_HEIGHT = 100
	MAX_WIDTH = 100

	MONTHS = [
		"January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"
	]

	MONTHS_SHORT = [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
	]

	@debug = false
	lastMonth = -1
	templateCache = {}
	container = ""

	@setContent = (posts) ->
		if @debug
			console.log "received posts:"
			console.log posts
		#posts.sort((a, b) -> b.timestamp - a.timestamp)

		for post in posts
			# should we add a month divider?
			date = new Date(post.timestamp * 1000)

			#templating
			ctx = createContext()
			ctx.date =
				year: date.getYear()
				month: date.getMonth()
				day: date.getDay()
				shortForm: makeDate(date.getMonth(), date.getDate())
				time: makeTime(date.getHours(), date.getMinutes())

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
				when "audio"  then ContentContext.setContextForAudio(post, ctx)
				when "photo"  then ContentContext.setContextForPhoto(post, ctx)
				when "quote"  then ContentContext.setContextForQuote(post, ctx)
				when "chat"   then ContentContext.setContextForChat(post, ctx)
				when "answer" then ContentContext.setContextForAnswer(post, ctx)

			# thumbnail dimensions
			ctx.height = ctx.thumbnail.height or MIN_HEIGHT

			# strip html from text
			#ctx.text = uqc.lib.stripHTML(ctx.text);
			ctx.text = $("<div>" + ctx.text + "</div>").text()

			# if title is too big, truncate it
			ctx.title = ctx.title.substring(0, 210) if ctx.title and ctx.title.length > 210

			# if text is too big, truncate it
			ctx.text = ctx.text.substring(0, 180) + " [...]" if ctx.text.length > 180
			lastMonth = date.getMonth()
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
		partial = UQC.trim(render(partial))
		renderTemplate(partial, this)
	;

	createContext = ->
		{
			dynamicPartial: -> renderPartial
		}
	;

	# --- helpers ---

	@createColumns = () ->
		# create a new container, add a date object
		container = $("<div class=\"container\">")

		i = 0

		while i < COLUMNS
			container.append $("<ul class=\"column\">")
			++i

		$(".grid").append container
	;

	append = (html) ->
		nodes = container.find("div.brick")
		col = (nodes.length) % COLUMNS
		node = $("<li class=\"stack\" style=\"display:none;\">")
		node.append(html)
		#$($(".grid .container:last ul.column")[col]).append(node)
		$(container.find("ul.column")[col]).append(node)
		node.fadeIn(600)
	;

	makeDate = (month, day) ->
		day += 1
		str = ""

		if day is 1 or day is 21 or day is 31
			str = "st"
		else if day is 2 or day is 22
			str = "nd"
		else if day is 3 or day is 23
			str = "rd"
		else
			str = "th"

		str = "#{MONTHS_SHORT[month]}. #{day}<sup>#{str}</sup>"
		return str
	;

	makeTime = (hours, minutes) ->
		pm = hours >= 12
		str = (hours % 12) + ":"
		str += (if minutes < 10 then "0" else "") + minutes
		str += if pm then "pm" else "am"
		return str
	;

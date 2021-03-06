
class Renderer

	constructor: () ->
		@templates = {}
		@$kiosk = $('[kiosk]')
		@$scene = $('#scene')
		@$characters = @$scene.find('.characters')
		@$leftScene = @$scene.find('.from-left')
		@containerWidth = 0
		@transitionSpeed = 5000
		@winWidth = $(window).outerWidth()

		self = @

		#store the handlebars templates
		$('[template]').each (e) ->
			el = $(this)
			self.templates[el.attr('template')] = Handlebars.compile(el.html())
	
	render : (data) =>
		console.log 'Templates : ', @templates
		console.log 'Raw data from /presentation : ', data

		@data = {}
		@data.id = data.id
		@data.slides = data.presentation_screens

		console.log('Slides : ', @data.slides)
		#store kiosk id in DOM
		@$kiosk.attr('kiosk', @data.id)

		#render the panels
		slides = @data.slides

		for i in [0...slides.length]
			slide = slides[i].screen
			@$kiosk.append @templates[slide.slide_type](slide)

		@attachEvents()
		@resizeSlides()
		@adjustScene () =>

			#start the slideshow
			@slideshow = new SlideShow({
				intervalSpeed : @transitionSpeed,
				debug : false
			})

			@slideshow.start()

	renderSchedule : (data) =>
		container = $('#events-list')
		container.html(@templates['events'](data))

	renderMaps : (data) =>
		console.log 'Maps : ', data
		container = $('#maps')
		container.html(@templates['maps'](data))

	renderAnnouncements : (data) =>
		container = $('#announcement-bubbles')
		# if no announcements, make a dummy one
		if !data.objects.length
			data.objects[0] = {
				title : "No Announcements at this time.",
				body : "Stay tuned.",
				main : true
			}
		container.html(@templates['bubbles'](data))

	resizeSlides : () =>
		self = @
		#force panels to be viewport height
		@$kiosk.find('.slide').each () ->
			el = $(this)
			el.height($(window).height())
			el.width($(window).outerWidth())
			self.containerWidth += el.outerWidth()

		@$kiosk.width(@containerWidth)

	adjustScene : (callback) =>
		callback = callback or () =>
		# @$scene.width(@containerWidth)
		self = @
		# adjust each "scene" section to the kiosk width
		# @$scene.find('section').width(self.containerWidth)
		# @$characters.height($(window).height())

		# @$characters.find('.group').each () ->
		# 	el = $(this)
		# 	el.width($(window).outerWidth())

		# @$leftScene.css('-webkit-transform', 'translateX(-'+(@containerWidth - $(window).outerWidth())+'px)')
		callback()

	attachEvents : () =>
		doc = $(document)

window.Renderer = Renderer

gulp = require 'gulp'
coffee = require 'gulp-coffee'
shell = require 'gulp-shell'

_scripts =
	'coffee': './src/coffee/*.coffee'
	'hbs': './src/hbs/popup.hbs'
	'copyElse': [ './src/**/*', '!./src/coffee', '!./src/coffee/*', '!./src/hbs', '!./src/hbs/*', '!./src/html', '!./src/html/*' ]
	'copyHtml': './src/html/*'

gulp.task 'coffee', ->
	# return
	gulp.src _scripts.coffee
		.pipe( coffee( ) )
		.pipe( gulp.dest( './build/') )

gulp.task 'templates', ->
	# return
	gulp.src _scripts.hbs
		.pipe( shell( [ "./node_modules/.bin/handlebars <%= file.path %> -e hbs -f ./build/popup-template.js " ] ) )

gulp.task 'watch', ->
	# return
	gulp.watch [ _scripts.coffee, _scripts.hbs ], [ 'coffee', 'templates' ]

gulp.task 'copyElse', ->
	# return
	gulp.src _scripts.copyElse
		.pipe( gulp.dest( './build/' ) )

gulp.task 'copyHtml', ->
	# return
	gulp.src _scripts.copyHtml
		.pipe( gulp.dest( './build/' ) )

gulp.task 'build', [ 'coffee', 'templates', 'copyHtml', 'copyElse' ]

gulp.task 'default', [ 'build' ]

gulp = require 'gulp'
coffee = require 'gulp-coffee'
shell = require 'gulp-shell'

gulp.task 'coffee', ->
	# return
	gulp.src './src/*.coffee'
		.pipe( coffee( ) )
		.pipe( gulp.dest( './build/') )

gulp.task 'templates', ->
	# return
	gulp.src './src/*.hbs'
		.pipe( shell( [ "./node_modules/.bin/handlebars <%= file.path %> -e hbs -f ./build/popup-template.js " ] ) )

gulp.task 'watch', ->
	gulp.watch [ './src/*.coffee', './src/*.hbs' ], [ 'coffee', 'templates' ]
	return

gulp.task 'default', [ 'coffee', 'templates' ]

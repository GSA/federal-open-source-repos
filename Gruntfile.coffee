module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    
    jst:
      app:
        options:
          processName: (filename) ->
            filename.replace('_templates/', '').replace('._', '')
          namespace: "RepoList.Templates"
        files:
          "_includes/js/templates.js": "_templates/*._"
          
    watch:
      cs:
        files: ["_cs/*"]
        tasks: [ 'coffeelint', 'coffee']
        options:
          interrupt: true
          forceWatchMethod: 'old'
      jst:
        files: ["_templates/*"]
        tasks: 'jst'
        options:
          interrupt: true
          forceWatchMethod: 'old' 

    coffeelint:
      app: "_cs/**.coffee"
    
    coffee:
      app:
        files: 
          "_includes/js/app.js": "_cs/app.coffee"
          
    uglify:
      app:
        files:
          "_includes/js/app.js": "_includes/js/app.js"
      templates:
        files:
          "_includes/js/templates.js": "_includes/js/templates.js"

                  
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-mincss'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jekyll'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-css'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jst'

  grunt.registerTask 'cs', ["coffeelint", "coffee"]
  grunt.registerTask 'default', ["cs", "jst", "uglify"]
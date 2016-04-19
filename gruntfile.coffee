module.exports = (grunt) ->
    "use strict"
    grunt.util.linefeed = '\n'
    btoa = require 'btoa'
    
    grunt.initConfig

        # Metadata.
        pkg: grunt.file.readJSON 'package.json'
        banner: """/*!
                 * <%= pkg.name %> v<%= pkg.version %> (<%= pkg.homepage %>)
                 * Copyright <%= grunt.template.today('yyyy') %> <%= pkg.author %>
                 * Licensed under <%= _.pluck(pkg.licenses, 'url').join(', ') %>
                 */

                 """
        # Task configuration.
        clean: 
            build: ['build/']
            dist: ['dist/']        
        jshint:
            options:
                jshintrc: '.jshintrc'
            src:
                src: ['<%= coffee.build.dest %>']
        coffee:
            src:
                options:
                    bare: true
                    sourceMap: true
                src: ''
                dest: 'build/js/<%= pkg.name %>.js'
            test:
                options:
                    sourceMap: false
                    bare: true
                src: 'tests/**/*.coffee'
                dest: 'tests/tests.js'
        copy:    
            dist:
                expand: true
                cwd: 'build/'
                src: ['**']
                dest: 'dist/'    
        less:
            dist:
                options:
                    strictMath: true
                    sourceMap: true
                    outputSourceFiles: true
                    
                    sourceMapURL: '<% pkg.name %>.css.map'
                    sourceMapFilename: 'dist/css/<%= pkg.name %>.css.map'
                files: ['dist/css/<%= pkg.name %>.css': 'src/less/awesomesauce.less']
        uglify:
            options:
                banner: '<%= banner %>'
            core:
                src: ['<%= coffee.src.dest %>']
                dest: 'build/js/<%= pkg.name %>.min.js'
        qunit: 
            options: 
                inject: 'tests/lib/phantom.js'
            files: ['tests/index.html']

        watch: 
            src: 
                files: '<%= jshint.src.src %>'
                tasks: ['jshint:src', 'qunit']
            test: 
                files: '<%= jshint.test.src %>'
                tasks: ['jshint:test', 'qunit']
        yuidoc:
            src:
                options:
                    paths: 'js',
                    themedir:  'docs-theme',
                    outdir: 'build/docs'

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-jshint'
    grunt.loadNpmTasks 'grunt-contrib-qunit'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-yuidoc'

    grunt.registerTask 'test', []
    grunt.registerTask 'build', ['clean:build']
    grunt.registerTask 'dist', ['clean:dist', 'copy:dist']
    grunt.registerTask 'default', ['build', 'test', 'dist']
 
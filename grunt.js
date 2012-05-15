/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', '<file_strip_banner:lib/<%= pkg.name %>.js>'],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    jasmine: {
      files: [ 'spec' ],
      options: [ 'coffee' ]
    },
    lint: {
      files: ['grunt.js', 'lib/**/*.js']
    },
    watch: {
      files: '<config:lint.files>',
      tasks: 'lint jasmine'
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        browser: true
      },
      globals: {
        jQuery: true
      }
    },
    uglify: {}
  });


  // Jasmine Runner
  grunt.registerTask('jasmine', 'Run Jasmine tests with NodeJS', function() {
    var cfg  = grunt.config(['jasmine']),
        done = this.async();

    grunt.helper( 'jasmine-node', {
      args : [
        'node_modules/jasmine-node/bin/jasmine-node',
        cfg.files.join(''),
        cfg.options.map(function(i) {
          return '--' + i;
        }).join(' ')
      ],
      done : function(err) {
        done( err ? false : null );
      }
    });
  });

  // Jasmine-Node
  grunt.registerHelper('jasmine-node', function(options) {
    return grunt.utils.spawn({
      cmd : 'node',
      args : options.args
    }, function(err, result, code) {
      if( err ) {
        grunt.log.error( result.stdout );
      } else {
        grunt.log.write( result.stdout );
      }
      return options.done(code);
    });
  });


  // Default task.
  grunt.registerTask('default', 'lint jasmine concat min');

};

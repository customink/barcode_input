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
        src: ['<banner:meta.banner>', '<file_strip_banner:compiled/<%= pkg.name %>.js>'],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    mocha: {
      index: ['test/runner.html']
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
        immed: false,
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
    uglify: {},
    coffee: {
      app: {
        src: [ 'lib/**/*.coffee' ],
        dest: 'compiled',
        options : {
          bare : false
        }
      },
      test: {
        src: [ 'test/*.coffee' ],
        dest: 'test/compiled',
        options : {
          base : false
        }
      },
      spec: {
        src: [ 'test/spec/*.coffee' ],
        dest: 'test/spec/compiled',
        options : {
          bare : false
        }
      }
    },
    component: {
      main: [
        './dist/jquery.barcode_input.js',
        './dist/jquery.barcode_input.min.js'
      ],
      dependencies: {
        jwerty: 'https://raw.github.com/keithamus/jwerty/19bac3b27848a5083b88fcf140efbcd0f7c8421f/jwerty.js'
      }
    }
  });

  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-mocha');
  grunt.loadNpmTasks('grunt-pkg-to-component');

  grunt.registerTask('test', 'coffee mocha');

  // Default task.
  grunt.registerTask('default', 'lint test concat min component');
};

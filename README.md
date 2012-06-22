# jQuery Barcode Input

An incredibly simple Javascript handler for barcode scanner input.

## Getting Started
Download the [production version][min] or the [development version][max].

In your web page:

```html
<script src="jquery.js"></script>
<script src="dist/jquery.barcode_input.min.js"></script>
...
<input type="text" data-barcode-input>
```

## Documentation

_(Coming soon)_

## Examples

_(Coming soon)_

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style.
Add unit tests for any new or changed functionality.
Lint and test your code using [grunt].

_Also, please don't edit files in the "dist" subdirectory as they are
generated via grunt. You'll find source code in the "lib" subdirectory!_

### Development

    git clone git@github.com:customink/barcode_input.git
    cd barcode_input
    ./bin/kickstart.sh

### Testing

    node node_modules/jasmine-node/bin/jasmine-node spec --coffee

## License

Copyright (c) 2012 Derek Lindahl
Licensed under the MIT, GPL licenses.

[min]: https://raw.github.com/customink/jquery.barcode_input/master/dist/jquery.barcode_input.min.js
[max]: https://raw.github.com/customink/jquery.barcode_input/master/dist/jquery.barcode_input.js
[grunt]: https://github.com/cowboy/grunt
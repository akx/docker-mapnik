# docker-mapnik

> Mapnik Docker container with Node and Python bindings

## Building

> :exclamation:
> Ensure your Docker build environment, be it a VM (if you use Docker for Mac or Windows) or bare metal,
> has **at least 4 gigabytes of memory**. Any less and you'll have to enjoy hella swapping.

* Do `docker build -t mapnik .`. It will take a long while, so best get another coffee.


## Contents of the image

* Ubuntu 16.04 LTS
* Mapnik 3.0.10 (at the time of writing)
* Node.js 6.x

### Node bindings

* `/opt/node-mapnik` contains the Node bindings.
* They are `npm link`ed, so any apps requiring them _should_ be able to just `npm link mapnik`.

### Python bindings

* `/opt/python-mapnik` contains the Python bindings.
* The bindings are built for both Python 2.x and 3.x, and installed system-wide.
* If your app requires a virtualenv, `pip install -e /opt/python-mapnik` is likely your best bet.
* Otherwise, just `--system-site-packages` your virtualenv or don't use a virtualenv at all.

### Test apps

* The basic [Python world-rendering script][gspy] is installed in `/opt/demos/world.py`.
  * Use `cd /opt/demos; python2 world.py` to try that Python 2.x works.
  * Use `cd /opt/demos; python3 world.py` to try that Python 3.x works.
  * The script outputs a `world.png`. You can use `docker cp` to look at it.

* The [Node.js "render a map from a stylesheet"][rmjs] demo is installed in `/opt/demos/world.js`.
  * Use `cd /opt/demos; npm i mapnik; node world.js` to try it.
    You'll get a crapload of deprecation warnings (see the related [bug][sbug]) since we're running Node 6,
    but the script does output a `map.png` anyway. You can use `docker cp` to look at it.

[gspy]: https://github.com/mapnik/mapnik/wiki/GettingStartedInPython
[rmjs]: https://github.com/mapnik/node-mapnik#usage
[sbug]: https://github.com/mapbox/node-sqlite3/issues/634
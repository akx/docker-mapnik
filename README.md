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

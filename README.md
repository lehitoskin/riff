riff
====

riff is a racket wrapper for [FLIF](https://github.com/FLIF-hub/FLIF)

API is currently synced to FLIF version 0.3.0

# Installation
Note that while you may run `raco pkg install riff`, this possibly isn't the
command you want to run. `raco` will install from the latest git and that means
the package will be using the most up-to-date (unless I become lazy) version
of the FLIF API, which means that it will fail to run unless you have the most
up-to-date version of FLIF installed. Instead, what I recommend is that you
follow major releases of FLIF and get the most recent release of riff to match.
Thus, what you'll end up doing is after downloading and extracting the archive
of the most recent riff release, then running `raco pkg install
/local/path/to/riff`

# Usage
See the docs for information on usage.

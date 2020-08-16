# LinuxNotifier
[![Build Status](https://travis-ci.org/goropikari/LinuxNotifier.jl.svg?branch=master)](https://travis-ci.org/goropikari/LinuxNotifier.jl)
[![codecov.io](http://codecov.io/github/goropikari/LinuxNotifier.jl/coverage.svg?branch=master)](http://codecov.io/github/goropikari/LinuxNotifier.jl?branch=master)

This package is notification tools for Julialang on Linux.

```julia
using LinuxNotifier
notify("Task completed")
```
![Screenshot of a Notification](./pictures/linuxpopup.png?raw=true)

## Features:
- popup notification (desktop notification)
- sound notification
- say notification (Read a given message aloud)
- count up and count down timer

## Installation
```julia
using Pkg
Pkg.add("LinuxNotifier")
```

## Setup
Before using LinuxNotifier.jl, you need to install following softwares in your Linux system.
- `libnotify` for a desktop notification
- `aplay` (Advanced Linux Sound Architecture) for a sound notification
- `espeak` for reading a given message aloud

```bash
$ sudo apt install libnotify-bin alsa-utils espeak
```

## Usage
### popup notification
```julia
using LinuxNotifier
notify("Task completed")
# defalut title is "Julia".
# You can change the title by title option.
notify("Task completed", title="foofoo")
```

![Screenshot of a Notification](./pictures/linuxpopup.png?raw=true)


### sound and say notification
```julia
# only sound
alarm()

# You can specify a sound file
alarm(sound="/path/to/foo.wav")

# Default sound backend is `aplay`.
# `sox` and `vlc` are also supported.
# Change backend as follows.
aplay()
sox()
vlc()

# Read aloud
say("Finish calculation!")

# Default speak backend is `espeak`.
# `festival` is also supported.
# Change backend as follows.
espeak()
festival()
```

## Acknowledgement
Inspired by [OSXNotifier.jl](https://github.com/jonasrauber/OSXNotifier.jl).

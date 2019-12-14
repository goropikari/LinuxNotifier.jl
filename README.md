# Notifier
[![Build Status](https://travis-ci.org/goropikari/Notifier.jl.svg?branch=master)](https://travis-ci.org/goropikari/Notifier.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/cv0ilbo2f6d43xcp?svg=true)](https://ci.appveyor.com/project/goropikari/notifier-jl)
[![codecov.io](http://codecov.io/github/goropikari/Notifier.jl/coverage.svg?branch=master)](http://codecov.io/github/goropikari/Notifier.jl?branch=master)

This package is notification tools for Julialang.

```julia
using Notifier
notify("Task completed")
```
![Screenshot of a Notification](./docs/linuxpopup.png?raw=true)

 ## Features:
 - Linux and macOS
   - popup notification (desktop notification)
   - sound notification
   - say notification (Read a given message aloud)
   - email notification
   - count up and count down timer
 - Windows (Experimental)
   - popup notification (desktop notification)
   - sound notification
   - say notification (Read a given message aloud)
   - count up and count down timer

## Installation
```julia
using Pkg
Pkg.add("Notifier")
```

## Setup for Linux user
Before using Notifier.jl, you need to install following softwares in your Linux system.
- `libnotify` for a desktop notification
- `mail` for an e-mail notification
- `aplay` (Advanced Linux Sound Architecture) for a sound notification
- `espeak` for reading a given message aloud

```bash
$ sudo apt install libnotify-bin alsa-utils espeak mailutils heirloom-mailx bsd-mailx
```

This package uses `mail` command to notify by e-mail. You may need some settings in advance.
If following command works correctly, you don't need further setting.
```bash
$ echo test | mail -s foo yourmail@example.com
```

## Usage
### popup notification
```julia
using Notifier
notify("Task completed")
# defalut title is "Julia".
# You can change the title by title option.
notify("Task completed", title="foofoo")
notify("Task completed", sound=true) # with sound
notify("Task completed", sound="foo.wav") # Specify a sound file (for Linux and Windows)
```
Linux  
![Screenshot of a Notification](./docs/linuxpopup.png?raw=true)

macOS  
![Screenshot of a Notification](./docs/macpopup.png?raw=true)

Windows  
![Screenshot of a Notification](./docs/winpopup.png?raw=true)

### sound and say notification
```julia
alarm() # only sound. You can specify a sound file, alarm(sound="foo.wav")
say("Finish calculation!") # Read aloud
```


### e-mail notification
```julia
email("message", To="foo@example.com") # default subject is set by date.
email("message", subject="result", To="foo@example.com")
```


If you use `email` function frequently, I recommend you to register your email address by `register_email` function.
```julia
julia> register_email()
Type your desired recipient e-mail address to receive a notification.
e-mail: foo@example.com

Recipient e-mail address is saved at /path/to/.julia/v0.6/Notifier/email/address.txt.
If you want to change the address, modify /path/to/.julia/v0.6/Notifier/email/address.txt directly or run register_email() again
```

After you registered, you don't need to specify e-mail address.
```julia
email("message")
```



### Timer
When the specified time limit has been reached, notify by sound.
```julia
h,m,s = 1,2,3
countup(h,m,s) # Hour, Minute, Second
countdown(h,m,s)
```


## Acknowledgement
Inspired by [OSXNotifier.jl](https://github.com/jonasrauber/OSXNotifier.jl).

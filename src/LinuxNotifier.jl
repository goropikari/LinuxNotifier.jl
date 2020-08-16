module LinuxNotifier

using Dates

import Base.notify
export notify,
       alarm,
       aplay,
       sox,
       vlc,
       say,
       countup,
       countdown

"""
---
    Notifier.notify(message;
                    title="Julia",
                    urgency="normal",
                    sound=false,
                    time=4,
                    app_name=PROGRAM_FILE,
                    sound_backend="aplay"
                    logo)

Notify by desktop notification.

# Arguments
- `urgency::AbstractString` : Urgency level ("low", "normal", "critical"). Default is "normal".
- `sound::Union{Bool, AbstractString}`: Play default sound or specific sound.
- `time::Real`: Display time (seconds).
- `logo`: Default is Julia logo
- `app_name::AbstractString` : Name of application sending the notification. Default is the name of your script (e.g. "test.jl") or "Julia REPL"/"Atom Juno" if using any of these two.
- `sound_backend::AbstractString` : a CLI audio program used ("aplay","sox","vlc")
"""
function notify(message::AbstractString;
                title="Julia",
                urgency::AbstractString="normal",
                time::Real=4,
                app_name::AbstractString=PROGRAM_FILE,
                logo::AbstractString=joinpath(@__DIR__, "logo.svg"),
                sound_backend::AbstractString="aplay")
    if app_name == "" && occursin("REPL", @__FILE__)   # Default for running in REPL
        app_name = "Julia REPL"
    elseif occursin("atom", app_name) && occursin("boot_repl.jl", app_name)  # Default for running in Juno
        app_name = "Atom Juno"
    end
    run(`notify-send $title $message -u $urgency -a $app_name -i $(logo) -t $(time * 1000)`)

    return
end
notify() = notify("Task completed.")


########
# alarm
########

abstract type SoundBackend end
struct Aplay <: SoundBackend end
struct Sox <: SoundBackend end
struct Vlc <: SoundBackend end

mutable struct CurrentSoundBackend
    backend::Type{T} where T <: SoundBackend
end

const _CURRENT_SOUND_BACKEND = CurrentSoundBackend(Aplay)
aplay() = _CURRENT_SOUND_BACKEND.backend = Aplay
sox() = _CURRENT_SOUND_BACKEND.backend = Sox
vlc() = _CURRENT_SOUND_BACKEND.backend = Vlc

"""
    Notifier.alarm(;sound="default.wav")

Notify by sound.
If you choose a specific sound WAV file, you can play it instead of the default sound.

Default backend is `aplay`. Supported backends are `aplay`, `sox`, and `vlc`.
You can change backends as follows:
```
aplay()
sox()
vlc()
```
"""
function alarm(; sound=joinpath(@__DIR__, "default.wav"))
    alarm(_CURRENT_SOUND_BACKEND.backend, sound)
    nothing
end
function alarm(::Type{Aplay}, sound)
    @async run(`aplay -q $sound`)
    nothing
end
function alarm(::Type{Sox}, sound)
    @async run(`play -q $sound`)
    nothing
end
function alarm(::Type{Vlc}, sound)
    @async run(pipeline(`cvlc --play-and-exit --no-loop $sound`, stderr=devnull))
    nothing
end

######
# say
######

abstract type SpeakBackend end
struct Espeak <: SpeakBackend end
struct Festival <: SpeakBackend end

mutable struct CurrentSpeakBackend
    backend::Type{T} where T <: SpeakBackend
end

const _CURRENT_SPEAK_BACKEND = CurrentSpeakBackend(Espeak)
epeak() = _CURRENT_SPEAK_BACKEND.backend = Espeak
festival() = _CURRENT_SPEAK_BACKEND.backend = Festival

"""
    Notifier.say(message::AbstractString)

Read a given message aloud.

"""
function say(msg::AbstractString)
    say(_CURRENT_SPEAK_BACKEND.backend, msg)
    nothing
end
function say(::Type{Espeak}, msg::AbstractString)
    run(pipeline(`espeak $msg`, stderr=devnull))
    nothing
end
function say(::Type{Festival}, msg::AbstractString)
    run(pipeline(`echo $msg`, `festival --tts`))
    nothing
end

end # module

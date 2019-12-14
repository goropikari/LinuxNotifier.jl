export alarm, say

include("email.jl")

"""
---
    Notifier.notify(message; title="Julia", sound=false, time=4, logo)

Notify by desktop notification.

# Arguments
- `urgency::AbstractString` : Urgency level ("low", "normal", "critical"). Default is "normal".
- `sound::Union{Bool, AbstractString}`: Play default sound or specific sound.
- `time::Real`: Display time.
- `logo`: Default is Julia logo
- `app_name::AbstractString` : Name of application sending the notification. Default is the name of your script (e.g. "test.jl") or "Julia REPL"/"Atom Juno" if using any of these two.
- `sound_backend::AbstractString` : a CLI audio program used ("aplay","sox","vlc")
"""
function notify(message::AbstractString;
                title="Julia",
                urgency::AbstractString="normal",
                sound::Union{Bool, AbstractString}=false,
                time::Real=4,
                app_name::AbstractString=PROGRAM_FILE,
                logo::AbstractString=joinpath(@__DIR__, "logo.svg"),
                sound_backend::AbstractString="aplay")
    if app_name == "" && occursin("REPL", @__FILE__)   # Default for running in REPL
        app_name = "Julia REPL"
    elseif occursin("atom", app_name) && occursin("boot_repl.jl", app_name)  # Default for running in Juno
        app_name = "Atom Juno"
    end
    if sound == true || typeof(sound) <: AbstractString
        if sound == true
            alarm(backend=sound_backend)
        elseif ispath(sound)
            alarm(sound=sound, backend=sound_backend)
        end
    end
    run(`notify-send $title $message -u $urgency -a $app_name -i $(logo) -t $(time * 1000)`)

    return
end
notify() = notify("Task completed.")

"""
    Notifier.alarm(;sound="default.wav")

Notify by sound.
If you choose a specific sound WAV file, you can play it instead of the default sound.

# Arguments
- `backend::AbstractString` : a CLI audio program used ("aplay","sox","vlc")
"""
function alarm(;sound::AbstractString=joinpath(@__DIR__, "default.wav"),
                backend::AbstractString="aplay")
    if backend == "aplay"
        @async run(`aplay -q $sound`)
    elseif backend == "sox"
        @async run(`play -q $sound`)
    elseif backend == "vlc"
        @async run(`cvlc --play-and-exit --no-loop $sound 2> /dev/null`)
    end
    return nothing
end

"""
    Notifier.say(message::AbstractString)

Read a given message aloud.

# Arguments
- `backend::AbstractString` : a CLI test-to-speech program used to synthesize speech ("espreak","festival")
"""
function say(msg::AbstractString;
            backend::AbstractString="espeak")
    if backend == "espeak"
        run(pipeline(`espeak $msg`, stderr=devnull))
    elseif backend == "festival"
        run(pipeline(`echo $msg`, `festival --tts`))
    end
end

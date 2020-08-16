module LinuxNotifier

using Dates

import Base.notify
export notify, alarm, say, countup, countdown

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
        @async run(pipeline(`cvlc --play-and-exit --no-loop $sound`, stderr=devnull))
    end
    return nothing
end

"""
    Notifier.say(message::AbstractString)

Read a given message aloud.

# Arguments
- `backend::AbstractString` : a CLI test-to-speech program used to synthesize speech ("espeak","festival")
"""
function say(msg::AbstractString;
            backend::AbstractString="espeak")
    if backend == "espeak"
        run(pipeline(`espeak $msg`, stderr=devnull))
    elseif backend == "festival"
        run(pipeline(`echo $msg`, `festival --tts`))
    end
end


"""
    countup(hour::T, min::T, sec::T) where T <: Integer

    countup(t::Time)
"""
function countup(hour::T, minute::T, second::T) where T <: Integer
    print_time(0)
    for t in 1:(hour*3600 + minute * 60 + second)
        update_printtime(t)
    end
    alarm()
end
countup(minute::T, second::T) where T <: Integer = countup(0, minute, second)
countup(second::T) where T <: Integer = countup(0, 0, second)
countup(t::Time) = countup(Hour(t).value, Minute(t).value, Second(t).value)
countup(h::Hour) = countup(h.value, 0, 0)
countup(m::Minute) = countup(0, m.value, 0)
countup(s::Second) = countup(0, 0, s.value)

"""
    countdown(hour::T, minute::T, second::T) where T <: Integer

    countdown(t::Time)
"""
function countdown(hour::T, minute::T, second::T) where T <: Integer
    print_time(hour*3600 + minute * 60 + second)
    for t in (hour*3600 + minute * 60 + second)-1:-1:0
        update_printtime(t)
    end
    alarm()
end
countdown(minute::T, second::T) where T <: Integer = countdown(0, minute, second)
countdown(second::T) where T <: Integer = countdown(0, 0, second)
countdown(t::Time) = countdown(Hour(t).value, Minute(t).value, Second(t).value)
countdown(h::Hour) = countdown(h.value, 0, 0)
countdown(m::Minute) = countdown(0, m.value, 0)
countdown(s::Second) = countdown(0, 0, s.value)

"""
    s2hms(tsec::Int)

Convert seconds to (hour, minute, second)
"""
function s2hms(tsec::Int)
    h = div(tsec,3600)
    m = mod(div(tsec,60), 60)
    s = mod(tsec,60)

    return h, m, s
end

function print_time(t::Int)
    h, m, s = s2hms(t)
    if isdefined(Main, :IJulia)
        print(stderr, Time(h,m,s))
    else
        println(stderr, Time(h,m,s))
    end
end

function updatetime()
    sleep(1)

    # ProgressMeter.jl: print(stderr, "\r\u1b[K\u1b[A") is quated from
    # https://github.com/timholy/ProgressMeter.jl/blob/2c5683bec16ba50d00bf7d8e267eda7ff7d74623/src/ProgressMeter.jl#L299
    print(stderr, "\r\u1b[K\u1b[A")
end

function update_printtime(t::Int)
    updatetime()
    print_time(t)
end



end # module

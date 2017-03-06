input
    $1

output
    $2

def weighted_velocity(event, x)
    result := (event.velocity * x[event.channel]) / 127

init
    from
        i := 0
    until
        i > 15
    loop
        x[i] := 127
        i := i + 1
    end

transform
    case event.type
    when "note on" then
        event := note_on(event.channel, event.pitch, weighted_velocity(event, x))
    when "note off" then
        event := note_off(event.channel, event.pitch, weighted_velocity(event, x))
    when "controller" then
        if event.meta = 11 then
            v := event.value
            if event.fine then
                v := v / 128
            end
            x[event.channel] := v
            skip
        end
    else
    end

end

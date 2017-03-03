input
    $1

output
    $2

init
    x[0] := 127
    x[1] := 127
    x[2] := 127
    x[3] := 127
    x[4] := 127
    x[5] := 127
    x[6] := 127
    x[7] := 127
    x[8] := 127
    x[9] := 127
    x[10] := 127
    x[11] := 127
    x[12] := 127
    x[13] := 127
    x[14] := 127
    x[15] := 127

transform
    case event.type
    when "note on" then
        v := (event.velocity * x[event.channel]) / 127
        event := note_on(event.channel, event.pitch, v)
    when "note off" then
        v := (event.velocity * x[event.channel]) / 127
        event := note_off(event.channel, event.pitch, v)
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

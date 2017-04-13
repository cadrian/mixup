-- utf-8 to iso

input
    $1

output
    $2

transform
    case event.type
    when "text_event" then
        s := utf_to_iso(event.value)
        event := text_event(s)
    when "copyright_event" then
        s := utf_to_iso(event.value)
        event := copyright_event(s)
    when "track_name_event" then
        s := utf_to_iso(event.value)
        event := track_name_event(s)
    when "instrument_name_event" then
        s := utf_to_iso(event.value)
        event := instrument_name_event(s)
    when "lyrics_event" then
        s := utf_to_iso(event.value)
        event := lyrics_event(s)
    when "marker_text_event" then
        s := utf_to_iso(event.value)
        event := marker_text_event(s)
    else
    end

end

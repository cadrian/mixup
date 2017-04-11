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
    else
    end

end

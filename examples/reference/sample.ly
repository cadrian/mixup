% ---------------- Generated using MiXuP ----------------

\include "mixup-partitur.ily"

\header {
mixup-partitur = "sample"
}

\book {
\score {
<<
\new Staff = "soprano1" <<
\set Staff.instrumentName = "Soprano"
\set Staff.shortInstrumentName = "S."
\new Voice = "soprano1voice" {
\relative c' {
 \clef "G"
 \key c \major
 \override Staff.TimeSignature #'style = #'default \time 4/4
 c4 d4 e4 f4 | g4 a4 b4 c4 | c,1
}
}
\new Lyrics = "soprano1x1" \lyricsto "soprano1voice" {
\lyricmode {
 "doe" "ray" "me" "far" "sew" "la" "tea" "doe," "doe..."
}
}
\new AltLyrics = "soprano1x2" \lyricsto "soprano1voice" {
\lyricmode {
 "do" "re" "mi" "fa" "so" "la" "ti" "do," "do."
}
}
>>
\new Staff = "alto2" <<
\set Staff.instrumentName = "Alto"
\set Staff.shortInstrumentName = "A."
\new Voice = "alto2voice" {
\relative c' {
 \clef "G"
 \key c \major
 \override Staff.TimeSignature #'style = #'default \time 4/4
 r1 | c4 d4 e4 f4 | e1
}
}
\new Lyrics = "alto2x1" \lyricsto "alto2voice" {
\lyricmode {
 "do" "re" "mi" "fa" "so" "la"
}
}
>>
>>
}
}

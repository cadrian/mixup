% ---------------- Generated using MiXuP ----------------
\version "2.12.3"

\include "mixup.ily"
\header {
mixuppartitur = "berceaux"
title = \markup{\huge{\sans "Les Berceaux"}}
subtitle = \markup{\small{\italic "Mélodie"}}
poet = \markup{"Sully" \sans "Prudhomme"}
composer = \markup{"Gabriel" \sans "Fauré"}
}

\book {
\include "mixup-partitur.ily"
\score {
<<
\new Staff = "lied1" <<
\set Staff.instrumentName = "Lied"
\set Staff.shortInstrumentName = ""
\new Voice = "lied1voice" {
\relative c' {
 \clef "G"
 \key des \major
 \override Staff.TimeSignature #'style = #'() \time 12/8
 R1. | R1. | f4.-\p bes4 bes8 aes4.~ aes4 aes8 | ges4.~ ges4 ges8 f2. | f4 des8 ees4 f8 aes4. f4 des8 | c2. bes4.~ bes8 r8 f'8 | f4. bes4 bes8 aes2. | ges4.~ ges4 ges8 f2. | f4 des8 ees4 f8 f4. ees4 des8 | c2. c2.~ | \override Staff.TimeSignature #'style = #'() \time 6/8
 c4. r4 r8 | \override Staff.TimeSignature #'style = #'() \time 12/8

}
}
\new Lyrics = "lied1x1" \lyricsto "lied1voice" {
\lyricmode {
 "Le" "long" "du" "Quai," "les" "grands" "vais" -- "seaux," "Que" "la" "hou" -- "le in" -- "cli" -- "ne en" "si" -- "len" -- "ce," "Ne" "pren" -- "nent" "pas" "gar" -- "de aux" "ber" -- "ceaux," "Que" "la" "main" "des" "fem" -- "mes" "ba" -- "lan" -- "ce." "" "" "" "" "" "" "" "" "" ""
}
}
>>
\new PianoStaff = "piano" <<
\set PianoStaff.instrumentName = "Piano"
\set PianoStaff.shortInstrumentName = ""
\new Staff = "piano2" <<
\new Voice = "piano2voice" {
\relative c' {
 \clef "G"
 \key des \major
 \override Staff.TimeSignature #'style = #'() \time 12/8
 bes4\(-\p f'8 bes4 f8
 bes,4 f'8 bes4 f8
 | bes,4 f'8 bes4 f8
 bes,4 f'8 bes4 f8\)
 |
 bes,4\( f'8 bes4 f8
 aes,4 f'8 aes4 f8
 | ges,4 f'8 ges4 f8
 aes,4 f'8 aes4 f8
 | bes,4 f'8 bes4 f8
 des4 f8 des'4 f,8\)
 |
 c4\( f8 c'4 f,8
 bes,4 f'8 bes4 f8
 | bes,4 f'8 bes4 f8
 aes,4 f'8 aes4 f8
 | ges,4 f'8 ges4 f8
 aes,4 f'8 aes4 f8\)
 |
 bes,4\( f'8 bes4 f8
 c4 f8 c'4 f,8
 | c4 g'8 c4 g8
 c,4 f8 c'4 f,8
 | \override Staff.TimeSignature #'style = #'() \time 6/8
 c4 f8 c'4 f,8\)
 | \override Staff.TimeSignature #'style = #'() \time 12/8


}
}
>>
\new Staff = "piano3" <<
\new Voice = "piano3voice" {
\relative c' {
 \clef "F"
 \key des \major
 \override Staff.TimeSignature #'style = #'() \time 12/8
 bes,8 f'8 des'8~
 des8 des8 f,8

 bes,8 f'8 des'8~
 des8 des8 f,8

 | bes,8 f'8 des'8~
 des8 des8 f,8

 bes,8 f'8 des'8~
 des8 des8 f,8

 | bes,8 f'8 des'8~
 des8 des8 f,8

 bes,8 f'8 c'8~
 c8 c8 f,8

 | bes,8 f'8 bes8~
 bes8 bes8 f8

 aes,8 f'8 c'8~
 c8 c8 f,8

 | ges,8 f'8 des'8~
 des8 des8 f,8

 f,8 f'8 aes8~
 aes8 aes8 f8

 | f,8 a'8 ees'8~
 ees8 ees8 a,8

 bes,8 f'8 des'8~
 des8 des8 f,8

 | bes,8 f'8 des'8~
 des8 des8 f,8

 bes,8 f'8 c'8~
 c8 c8 f,8

 | bes,8 f'8 bes8~
 bes8 bes8 f8

 aes,8 f'8 c'8~
 c8 c8 f,8

 | g,8 f'8 des'8~
 des8 des8 f,8

 aes,8 f'8 c'8~
 c8 c8 f,8

 | c8 bes'8 e8~
 e8 e8 bes8

 f,8 c'8 a'8~
 a8 a8 c,8

 | \override Staff.TimeSignature #'style = #'() \time 6/8
 f,8 c'8 a'8~
 a8 a8 c,8

 | \override Staff.TimeSignature #'style = #'() \time 12/8

}
}
>>
>>
>>
}
}

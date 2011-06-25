% ---------------- Generated using MiXuP ----------------
\version "2.12.3"

\include "mixup.ily"
\header {
mixuppartitur = "berceaux"
title = \markup{\sans\huge\center-column{{\line{"Les Berceaux"}
}}}
subtitle = \markup{\override #'(box-padding . 1.0) \override #'(baseline-skip . 2)
\small{\italic\center-column{\line{"Mélodie"}
}}}
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
 R1. | R1. | f4.\(^\markup{\dynamic p \italic "sempre"} bes4 bes8 aes4.~ aes4 aes8 | ges4.~ ges4 ges8 f2.\)
 | f4\( des8 ees4 f8 aes4. f4 des8 | c2. bes4.~ bes8\)
 r8 f'8\( | f4. bes4 bes8 aes2. | ges4.~ ges4 ges8 f2.\)
 | f4\( des8 ees4 f8 f4. ees4 des8 | c2. c2.~ | \override Staff.TimeSignature #'style = #'() \time 6/8
 c4.\)
 r4 r8 | \override Staff.TimeSignature #'style = #'() \time 12/8
 f4.\(^\markup{\italic "cresc. poco a poco"} c'4. bes4. f4. | ees4. f4 ges8 f2.\)
 | f4\( f8 bes4. bes4 bes8 aes4 ges8 | f2. ges2.\)
 | ges4.\(^\markup{\italic "cresc. molto"} aes4 bes8 c2. | bes4. c4 des8 ees2.\)
 | fes4.\(^\markup{\dynamic f \italic "sempre"} ees4 des8 c4 bes8 a4 bes8 | f'1. | f,2.~ f4.\)
 r4 r8 | R1. | f4.\(^\markup{\dynamic pp} bes4 bes8 aes4.~ aes4 aes8 | ges4.~ ges4 ges8 f2.\)
 | f4.\( des4 ees8 f4 f8 ees4 des8 | c2. c2.\)
 | f4.\(^\markup{\italic "cresc."} a4 c8 ees2. | des4. c4 bes8 c4. f,4.\)
 | r2. bes2.^\markup{\dynamic mf}\( | aes2. aes4. bes4 aes8 | aes2.~ aes4. ges4. | f1.\)
 | r2. f2.^\markup{\dynamic p}\( | bes2. bes4. aes4 ges8 | f2.~ f4. f4. | bes,1.~ | bes2.\)
 r2. | R1. |
}
}
\new Lyrics = "lied1x1" \lyricsto "lied1voice" {
\lyricmode {
 "Le" "long" "du" "Quai," "les" "grands" "vais" -- "seaux," "Que" "la" "hou" -- "le in" -- "cli" -- "ne en" "si" -- "len" -- "ce," "Ne" "pren" -- "nent" "pas" "gar" -- "de aux" "ber" -- "ceaux," "Que" "la" "main" "des" "fem" -- "mes" "ba" -- "lan" -- "ce." "Mais" "vien" -- "dra" "le" "jour" "des" "a" -- "dieux," "Car" "il" "faut" "que" "les" "fem" -- "mes" "pleu" -- "rent," "Et" "que" "les" "hom" -- "mes" "cu" -- "ri" -- "eux" "Ten" -- "tent" "les" "ho" -- "ri" -- "zons" "qui" "leur" -- "rent !" "Et" "ce" "jour" "là" "les" "grands" "vais" -- "seaux," "Fuy" -- "ant" "le" "port" "qui" "di" -- "mi" -- "nu" -- "e," "Sen" -- "tent" "leur" "mas" -- "se" "re" -- "te" -- "nu" -- "e" "Par" "l'â" -- "me" "des" "loin" -- "tains" "ber" -- "ceaux," "Par" "l'â" -- "me" "des" "loin" -- "tains" "ber" -- "ceaux." "" "" "" "" "" "" "" "" "" "" ""
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
 bes4\(-\markup{\dynamic p} f'8 bes4 f8
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

 c4\(^\markup{\italic "cresc. poco a poco"} f8 c'4 f,8
 bes,4 f'8 bes4 f8
 | c4 ges'8 c4 ges8
 ces,4 f8 ces'4 f,8
 | bes,4 f'8 bes4 f8
 c4 bes'8 c4 bes8
 | d,4 a'8 d4 a8
 ees4 ges8 ees'4 ges,8\)
 |
 ees4\(^\markup{\italic "cresc. molto"} ges8 ees'4 ges,8
 ees4 ges8 ees'4 ges,8
 | ees4 ges8 ees'4 ges,8
 ees4 ges8 ees'4 ges,8\)
 |
 fes4\(^\markup{\dynamic f \italic "sempre"} ges8 fes'4 ges,8
 fes4 ges8 fes'4 ges,8
 | f4 aes8 <des f>4 aes8
 f4 aes8 <des f>4 aes8
 | r4 aes8 <f f'>4 aes8
 f4 ces8 f,4 ces'8
 | f4 ces8 f,4 ces'8
 f4-\markup{\dynamic p} c8 f,4 c'8\)
 |
 bes4\(-\markup{\dynamic pp} f'8 bes4 f8
 aes,4 f'8 aes4 f8
 | ges,4 f'8 ges4 f8
 aes,4 f'8 aes4 f8
 | bes,4 f'8 bes4 f8
 c4 f8 c'4 f,8
 | c4 g'8 c4 g8
 c,4 f8 c'4 f,8\)
 |
 c4\(-\markup{\italic "cresc."} f8 <a c>4 f8
 des4 ges8 <bes ees>4 ges8
 | des4-\< bes'8 <des ees>4 bes8
 f,4 c'8 f4 c8
 | f,4-\markup{\dynamic mf} bes8 <d f>4 bes8
 ees,4-\> bes'8 <des ees>4 bes8
 | ees,4-\markup{\dynamic p} aes8 <c ees>4 aes8
 des4 aes'8 <ces des>4 aes8
 | des,4 aes'8 <bes des>4 aes8
 c,4-\> ges'8 <bes c>4 ges8\)
 |
 bes,4\(-\markup{\dynamic pp} f'8 bes4 f8
 aes,4 f'8 aes4 f8
 | ges,4 f'8 ges4 f8
 aes,4 f'8 aes4 f8
 | bes,4 f'8 bes4 f8
 c4 f8 c'4 f,8
 | des4 f8 des'4 f,8
 c4 f8 c'4 f,8
 | bes,4 f'8 bes4 f8
 bes,4 f'8 bes4 f8
 | bes,4.~ bes4 f'8 bes4.~ bes4 f8~ | <bes, f'>2.~ <bes f'>4. r4 r8\) |

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

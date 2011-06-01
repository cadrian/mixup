#(define-markup-command (pencil layout props text) (markup?)
  "Print the string argument pencil-like."
  (interpret-markup layout
   (cons '((font-name . "Hilde") (font-shape . upright)
           (font-series . medium)) props)
   (make-with-color-markup (x11-color 'grey40) text)))

\layout {
  \context {
    \ChoirStaff
    \name "SemiChoirStaff"
    \consists "Span_bar_engraver"
    \override SpanBar #'stencil =
    #(lambda (grob)
      (if (string=? (ly:grob-property grob 'glyph-name) "|")
       (set! (ly:grob-property grob 'glyph-name) ""))
      (ly:span-bar::print grob))
  }
  \context {
    \Score
    \accepts "SemiChoirStaff"
    \override VerticalAxisGroup #'line-break-system-details = #'((minimum-Y-extent . (-30 . 10)))
  }
}

#(set-global-staff-size 21)
#(set-default-paper-size "a4")
#(ly:set-option 'point-and-click #f)

\layout {
  \context {
    \Score
    \override StaffSymbol #'ledger-line-thickness = #'(1.0 . 0)
    \override BarLine #'hair-thickness = #0.8
    \override BarLine #'thick-thickness = #2.0
  }
  \context {
    \Lyrics
    \name AltLyrics
    \alias Lyrics
    \override StanzaNumber #'font-series = #'medium
    \override LyricText #'font-shape = #'italic
    \override LyricText #'color = #(x11-color 'grey20)
  }
  \context {
    \StaffGroup
    \accepts AltLyrics
  }
}

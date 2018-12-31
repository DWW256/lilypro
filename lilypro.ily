\paper {
  #(set-paper-size "letter")
  ragged-bottom = ##t
  
  %{ Fancy fonts: apply fonts.scm patch before using on 2.18.0–2.19.11.
  
  #(define fonts
    (set-global-fonts
      #:music "emmentaler"
      #:brace "emmentaler"
      #:roman "TeX Gyre Pagella"
      #:sans "Cantarell"
      #:typewriter "Fira Mono"
      #:factor (/ staff-height pt 20)
  ))
  
  %}
}

\header {
  tagline = ##f
}

global-lilypro = {
  \override Score.BarNumber.break-visibility = ##(#f #t #t)
  \set minorChordModifier = \markup { "-" }
  \set majorSevenSymbol = \markup {\whiteTriangleMarkup 7}
}

subitoP = \tweak DynamicText.self-alignment-X #RIGHT #(make-dynamic-script
  (markup #:line (#:normal-text
                  #:italic "subito"
                  #:dynamic "p")))

subitoF = \tweak DynamicText.self-alignment-X #RIGHT #(make-dynamic-script
  (markup #:line (#:normal-text
                  #:italic "subito"
                  #:dynamic "f")))

sustainReset = \sustainOff\sustainOn

%{ Unfinished

hideInstrument = {
  \omit Staff.BarLine
  \omit Staff.Clef
  \omit Staff.InstrumentName
  \omit Staff.KeySignature
  \omit Score.TimeSignature
  \omit Staff.StaffSymbol
}

showInstrument = {
  \undo \omit Staff.BarLine
  \undo \omit Staff.Clef
  \undo \omit Staff.InstrumentName
  \undo \omit Staff.KeySignature
  \undo \omit Staff.TimeSignature
  \undo \omit Staff.StaffSymbol
}

%}

\layout {
  \context {
    \PianoStaff
    \consists "Span_arpeggio_engraver"
  }
}
\midi {
  \context { \ChordNameVoice \remove "Note_performer" }
}

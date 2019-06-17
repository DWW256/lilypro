\paper {
  #(set-paper-size "letter")
  ragged-bottom = ##t
  #(define fonts
    (set-global-fonts
      #:music "emmentaler"
      #:brace "emmentaler"
      #:roman "TeX Gyre Pagella"
      #:sans "Cantarell"
      #:typewriter "Fira Mono"
      #:factor (/ staff-height pt 20)
  ))
}

\header {
  tagline = ##f
}

global-lilypro = {
	\accidentalStyle modern
	\override Score.BarNumber.break-visibility = ##(#f #t #t)
	\set minorChordModifier = \markup { "-" }
	\set majorSevenSymbol = \markup {\whiteTriangleMarkup 7}
}

keyNone = \withMusicProperty #'untransposable ##t \key c \major

#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1) (or (eq? n 6) (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1) (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (ly:make-pitch o n (/ a 4))))

#(define (naturalize music)
   (let ((es (ly:music-property music 'elements))
         (e (ly:music-property music 'element))
         (p (ly:music-property music 'pitch)))
     (if (pair? es)
         (ly:music-set-property!
          music 'elements
          (map (lambda (x) (naturalize x)) es)))
     (if (ly:music? e)
         (ly:music-set-property!
          music 'element
          (naturalize e)))
     (if (ly:pitch? p)
         (begin
           (set! p (naturalize-pitch p))
           (ly:music-set-property! music 'pitch p)))
     music))

naturalizeMusic =
#(define-music-function (parser location m)
   (ly:music?)
   (naturalize m))

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
    	\Voice
    	\consists "Melody_engraver"
    	\override Stem #'neutral-direction = #'()
  	}
  	\context {
    	\PianoStaff
    	\consists "Span_arpeggio_engraver"
  	}
}
\midi {
  	\context { \ChordNameVoice \remove "Note_performer" }
}

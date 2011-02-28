deferred class MIXUP_PLAYER

feature {MIXUP_MIXER}
   set_score (name: STRING) is
      deferred
      end

   end_score is
      deferred
      end

   set_book (name: STRING) is
      deferred
      end

   end_book is
      deferred
      end

   set_partitur (name: STRING) is
      deferred
      end

   end_partitur is
      deferred
      end

   set_instrument (name: STRING) is
      deferred
      end

   set_dynamics (instrument, dynamics, position: STRING) is
      deferred
      end

   set_note (instrument: STRING; time_start, time_tactus: INTEGER; note: STRING; octave, duration: INTEGER) is
      deferred
      end

   set_lyric (instrument: STRING; time_start, time_tactus: INTEGER; lyric: STRING) is
      deferred
      end

   start_bar is
      deferred
      end

   end_bar is
      deferred
      end

end

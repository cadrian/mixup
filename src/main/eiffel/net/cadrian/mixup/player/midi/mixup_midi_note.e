-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_MIDI_NOTE

inherit
   MIXUP_MIDI_ITEM
   MIXUP_NOTE_VISITOR

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION) is
      do
         precision := section.precision
         note.accept(Current)
      end

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD) is
      do
         a_chord.do_all(agent (head: MIXUP_NOTE_HEAD; duration: INTEGER_64) is
                        local
                           events: MIXUP_MIDI_EVENTS
                        do
                           if not head.is_rest then
                              track.add_event(precision *  time            , events.note_event(track_id.to_integer_8, True , pitch(head), 64))
                              track.add_event(precision * (time + duration), events.note_event(track_id.to_integer_8, False, pitch(head), 64))
                           end
                        end(?, a_chord.duration))
      end

feature {MIXUP_LYRICS}
   visit_lyrics (a_lyrics: MIXUP_LYRICS) is
      do
         a_lyrics.note.accept(Current)
         a_lyrics.do_all(agent (syl: MIXUP_SYLLABLE) is
                         local
                            events: MIXUP_MIDI_META_EVENTS
                         do
                            log.info.put_line("SYLLABLE: %"" + syl.syllable + "%" at time " + time.out)
                            if syl.in_word then
                               track.add_event(precision * time, events.lyrics_event(syl.syllable))
                            else
                               track.add_event(precision * time, events.lyrics_event(" " + syl.syllable))
                            end
                         end)
      end

feature {}
   make (a_time: like time; a_note: like note; a_track: like track; a_track_id: like track_id) is
      require
         a_note /= Void
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         time := a_time
         note := a_note
         track := a_track
         track_id := a_track_id
      end

   time: INTEGER_64
   note: MIXUP_NOTE

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

   precision: INTEGER

   pitch (head: MIXUP_NOTE_HEAD): INTEGER_8 is
      require
         not head.is_rest
      do
         inspect
            head.note.out
         when "bis", "c" then
            Result := 0
         when "des", "cis" then
            Result := 1
         when "d" then
            Result := 2
         when "ees", "dis" then
            Result := 3
         when "e", "fes" then
            Result := 4
         when "f", "eis" then
            Result := 5
         when "ges", "fis" then
            Result := 6
         when "g" then
            Result := 7
         when "gis" then
            Result := 8
         when "aes" then
            Result := -4
         when "a" then
            Result := -3
         when "bes", "ais" then
            Result := -2
         when "b", "ces" then
            Result := -1
         end
         Result := Result + 12 * head.octave.to_integer_8
         if Result < 0 then
            Result := Result + 12
         elseif Result > 127 then
            Result := Result - 12
         end
      end

invariant
   note /= Void
   track /= Void
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_NOTE

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
class MIXUP_MUSIC_IDENTIFIER

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING is
      do
      end

   valid_anchor: BOOLEAN is
      do
         Result := music /= Void
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): MIXUP_MUSIC is
      do
         Result := music_evaluator.eval(a_commit_context)
         if Result = Void then
            fatal("Could not find identifier: " + identifier.out)
         end
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         debug
            log.trace.put_line("New events iterator for music identifier: " + identifier.as_name)
         end
         Result := music.new_events_iterator(a_context)
      end

   out_in_tagged_out_memory is
      do
         identifier.out_in_tagged_out_memory
         if music /= Void then
            tagged_out_memory.extend('=')
            music.out_in_tagged_out_memory
         end
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
         music.add_voice_ids(ids)
         log.info.put_line("Identifier " + identifier.out + " is music " + music.out + " (voices " + ids.out + ")")
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         music.set_timing(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_identifier: like identifier) is
      require
         a_source /= Void
         a_identifier /= Void
      do
         debug
            log.trace.put_line("Creating music identifier: " + a_identifier.as_name)
         end
         source := a_source
         identifier := a_identifier

         create music_evaluator.make(a_source, a_identifier)
      ensure
         source = a_source
         identifier = a_identifier
      end

   identifier: MIXUP_IDENTIFIER
   music: MIXUP_MUSIC

   music_evaluator: MIXUP_MUSIC_EVALUATOR

invariant
   identifier /= Void
   music_evaluator /= Void

end -- class MIXUP_MUSIC_IDENTIFIER

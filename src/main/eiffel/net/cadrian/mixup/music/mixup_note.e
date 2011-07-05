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
deferred class MIXUP_NOTE

inherit
   MIXUP_MUSIC
   VISITABLE

insert
   LOGGING

feature {ANY}
   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_SET_NOTE}.make(a_context.event_data(source), Current))
      end

   can_have_lyrics: BOOLEAN is
      deferred
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   frozen add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
      end

end -- class MIXUP_NOTE

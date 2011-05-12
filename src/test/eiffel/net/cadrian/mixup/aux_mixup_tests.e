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
deferred class AUX_MIXUP_TESTS

insert
   EIFFELTEST_TOOLS
   MIXUP_NODE_HANDLER
   MIXUP_NOTE_DURATIONS
   AUX_MIXUP_MOCK_PLAYER_EVENTS
   LOGGING

feature {}
   source: AUX_MIXUP_MOCK_SOURCE

   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(source, a_note, a_octave)
      end

   grammar: MIXUP_GRAMMAR

   parse (a_source: STRING): MIXUP_NODE is
      require
         a_source /= Void
      local
         parser_buffer: MINI_PARSER_BUFFER
         evaled: BOOLEAN
      do
         create parser_buffer
         parser_buffer.initialize_with(a_source)

         grammar.reset
         evaled := grammar.parse(parser_buffer)

         assert(evaled)
         assert(grammar.root_node /= Void)

         Result := grammar.root_node
      end

   file_content (a_name: FIXED_STRING): STRING is
      require
         a_name /= Void
      deferred
      ensure
         Result /= Void
      end

   read_file (a_name: FIXED_STRING): TUPLE[MIXUP_NODE, FIXED_STRING] is
      require
         a_name /= Void
      local
         node: MIXUP_NODE
      do
         node := parse(file_content(a_name))
         Result := [node, (a_name.out + ".mix").intern]
      end

   map (staff: INTEGER; voices: TRAVERSABLE[INTEGER]): MAP[TRAVERSABLE[INTEGER], INTEGER] is
      local
         ids: AVL_DICTIONARY[TRAVERSABLE[INTEGER], INTEGER]
      do
         create ids.make
         ids.add(create {AVL_SET[INTEGER]}.from_collection(voices), staff)
         Result := ids
      end

end -- class AUX_MIXUP_TESTS

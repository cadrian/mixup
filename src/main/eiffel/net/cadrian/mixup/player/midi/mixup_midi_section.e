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
class MIXUP_MIDI_SECTION

inherit
   MIXUP_ABSTRACT_SECTION[MIXUP_MIDI_OUTPUT_STREAM]

create {ANY}
   make

feature {ANY}
   generate (a_output: MIXUP_MIDI_OUTPUT_STREAM) is
      do
      end

   filename_in (a_filename: STRING) is
      require
         a_filename /= Void
      do
         a_filename.precede('-')
         a_filename.prepend(name)
         if parent /= Void then
            parent.filename_in(a_filename)
         end
      end

feature {}
   append_header (a_header: ABSTRACT_STRING) is
      do
      end

   append_body (a_body: ABSTRACT_STRING) is
      do
      end

   append_footer (a_footer: ABSTRACT_STRING) is
      do
      end

   make (section, a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         name := a_name.intern
         parent := a_parent
      end

end -- class MIXUP_MIDI_SECTION

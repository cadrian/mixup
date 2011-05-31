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
class MIXUP_LILYPOND_SECTION

insert
   MIXUP_ERRORS

create {ANY}
   make_full, make_body

feature {ANY}
   name: FIXED_STRING
   type: FIXED_STRING
   parent: MIXUP_LILYPOND_SECTION

   set_header (a_header: ABSTRACT_STRING) is
      require
         a_header /= Void
      do
         if header /= Void then
            header.append(a_header)
         else
            check parent /= Void end
            parent.set_header(a_header)
         end
      end

   set_body (a_body: ABSTRACT_STRING) is
      require
         a_body /= Void
      do
         body.append(a_body)
      end

   set_footer (a_footer: ABSTRACT_STRING) is
      require
         a_footer /= Void
      do
         if footer /= Void then
            footer.append(a_footer)
         else
            check parent /= Void end
            parent.set_footer(a_footer)
         end
      end

   generate (a_output: OUTPUT_STREAM) is
      require
         a_output.is_connected
      do
         if header /= Void then
            a_output.put_line(once "%% ---------------- Generated using MiXuP ----------------")
            a_output.put_line(once "\version %"2.12.3%"")
            a_output.put_new_line
            a_output.put_string(once "\include %"mixup.ily%"")
            a_output.put_new_line
            a_output.put_line(once "\header {")
            a_output.put_line(header)
            a_output.put_line(once "}")
            a_output.put_new_line
            a_output.put_line(once "\book {")
            a_output.put_line(once "\score {")
            a_output.put_line(once "<<")
         end

         a_output.put_string(once "\include %"mixup-")
         a_output.put_string(type)
         a_output.put_line(once ".ily%"")
         a_output.put_new_line
         a_output.put_line(body)

         if footer /= Void then
            a_output.put_line(once ">>")
            a_output.put_line(once "}")
            a_output.put_line(once "}")
            a_output.put_line(footer)
         end
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
   header: STRING
   body: STRING
   footer: STRING

   make (a_type, a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         type := a_type.intern
         name := a_name.intern
         parent := a_parent
      ensure
         type = a_type.intern
         name = a_name.intern
         parent = a_parent
      end

   make_body (a_type, a_name: ABSTRACT_STRING; a_parent: like parent) is
      require
         a_type /= Void
         a_name /= Void
         a_parent /= Void
      do
         make(a_type, a_name, a_parent)
         body := ""
      ensure
         header = Void
         footer = Void
      end

   make_full (a_type, a_name: ABSTRACT_STRING) is
      require
         a_type /= Void
         a_name /= Void
      do
         make(a_type, a_name, Void)
         body := ""
         header := ""
         footer := ""
      ensure
         parent = Void
         header /= Void
         footer /= Void
      end

invariant
   name /= Void
   type /= Void
   body /= Void
   header /= body
   footer /= body
   ;(parent = Void) /= (header = Void)
   ;(header = Void) = (footer = Void)
   header /= Void implies header /= footer

end -- class MIXUP_LILYPOND_SECTION

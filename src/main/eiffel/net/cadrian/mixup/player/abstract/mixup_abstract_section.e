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
deferred class MIXUP_ABSTRACT_SECTION[OUT_ -> MIXUP_ABSTRACT_OUTPUT]

insert
   MIXUP_ERRORS

feature {ANY}
   name: FIXED_STRING
   type: FIXED_STRING
   parent: like Current

   set_header (a_header: ABSTRACT_STRING) is
      require
         a_header /= Void
      do
         if parent = Void then
            append_header(a_header)
         else
            parent.set_header(a_header)
         end
      end

   set_body (a_body: ABSTRACT_STRING) is
      require
         a_body /= Void
      do
         append_body(a_body)
      end

   set_footer (a_footer: ABSTRACT_STRING) is
      require
         a_footer /= Void
      do
         if parent = Void then
            append_footer(a_footer)
         else
            parent.set_footer(a_footer)
         end
      end

   generate (a_output: OUT_) is
      require
         a_output.is_connected
      deferred
      end

feature {}
   append_header (a_header: ABSTRACT_STRING) is
      require
         a_header /= Void
      deferred
      end

   append_body (a_body: ABSTRACT_STRING) is
      require
         a_body /= Void
      deferred
      end

   append_footer (a_footer: ABSTRACT_STRING) is
      require
         a_footer /= Void
      deferred
      end

end -- class MIXUP_ABSTRACT_SECTION

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
class MIXUP_SOURCE_IMPL

inherit
   MIXUP_SOURCE
   MIXUP_LIST_NODE_IMPL_VISITOR
   MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
   MIXUP_TERMINAL_NODE_IMPL_VISITOR

insert
   MIXUP_NODE_HANDLER

create {ANY}
   make

feature {ANY}
   ast: MIXUP_NODE
   file: FIXED_STRING
   line: INTEGER
   column: INTEGER

   display (a_output: OUTPUT_STREAM) is
      local
         output: MIXUP_LINE_NUMBER_OUTPUT
      do
         if line > 0 then
            a_output.put_line(once "--8<------------------------------------------------------------8<--")
            create output.bind(a_output, line, 3)
            ast.generate(output)
            a_output.detach
            if column > 0 then
               if column > 1 then
                  a_output.put_string(output.blanks.substring(output.blanks.lower, output.blanks.lower + column - 2))
               end
               a_output.put_line("^")
            end
            a_output.put_line(once "-->8------------------------------------------------------------>8--")
         end
      end

feature {}
   make (a_ast: like ast; a_file: like file; a_line: like line; a_column: like column) is
      require
         a_ast /= Void
         a_file /= Void
         a_line >= 0
         a_column >= 0
      do
         ast := a_ast
         file := a_file
         line  :=  a_line
         column := a_column
      ensure
         ast = a_ast
         file = a_file
         line  =  a_line
         column = a_column
      end

invariant
   ast /= Void
   file /= Void
   line >= 0
   column >= 0

end -- class MIXUP_SOURCE_IMPL

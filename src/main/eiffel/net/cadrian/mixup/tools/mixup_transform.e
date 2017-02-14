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
class MIXUP_TRANSFORM
   --
   -- Main class of mix-transform
   --

insert
   ARGUMENTS
   LOGGING

create {}
   make

feature {}
   make
      local
         root: MIXUP_TRANSFORM_NODE
         inferer: MIXUP_TRANSFORM_INFERER
         interpreter: MIXUP_TRANSFORM_INTERPRETER
      do
         if argument_count = 0 then
            log.error.put_line("Usage: #(1) <file.mxt> ..." # command_name)
            log.error.put_line("The transform file is <file.mxt>")
            log.error.put_line("Extra arguments may be expected by the transform file")
            die_with_code(1)
         end
         root := eval(read_mxt(argument(1)))

         log.trace.put_line("**** INFER")
         create inferer.make(root)
         if inferer.error /= Void then
            log.error.put_line(inferer.error)
            die_with_code(1)
         end

         log.trace.put_line("**** INTERPRETE")
         create interpreter.make(root)
         if interpreter.error /= Void then
            log.error.put_line(interpreter.error)
            die_with_code(1)
         end

         log.trace.put_line("**** DONE")
      end

   eval (parser_buffer: MINI_PARSER_BUFFER): MIXUP_TRANSFORM_NODE
      local
         err: PARSE_ERROR
      do
         if not parser.eval(parser_buffer, grammar.table, once "Transformation") then
            log.error.put_line("Truncated transformation file")
            die_with_code(1)
         end
         if grammar.error /= Void then
            log.error.put_line(grammar.error)
            die_with_code(1)
         end
         if parser.error /= Void then
            from
               err := parser.error
            until
               err = Void
            loop
               log.error.put_line(err.message)
               err := err.next
            end
            die_with_code(1)
         end
         Result := grammar.root
      ensure
         Result /= Void
      end

   read_mxt (file: STRING): MINI_PARSER_BUFFER
      require
         file /= Void
      local
         mxt: STRING; stream: TEXT_FILE_READ
      do
         create stream.connect_to(file)
         if not stream.is_connected then
            log.error.put_line("File not readable: " + file)
            die_with_code(1)
         end

         mxt := once ""
         mxt.clear_count
         from
            stream.read_line
         until
            stream.end_of_input
         loop
            mxt.append(stream.last_string)
            mxt.extend('%N')
            stream.read_line
         end
         mxt.append(stream.last_string)

         stream.disconnect

         create Result.initialize_with(mxt)
      end

   grammar: MIXUP_TRANSFORM_GRAMMAR
      once
         create Result.make
      end

   parser: DESCENDING_PARSER
      once
         create Result.make
      end

end -- class MIXUP_TRANSFORM

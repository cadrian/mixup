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
class MIXUP_TRANSFORM_GRAMMAR

insert
   ARGUMENTS
   LOGGING
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM}
   make

feature {}
   the_table: PARSE_TABLE[DESCENDING_PARSE_CONTEXT] once then
      {PARSE_TABLE[DESCENDING_PARSE_CONTEXT]
      <<
        -- Non terminals

        "Transformation", {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "Input", "Output", "Init", "Transform", "KW:end" >> }, Void
                            >> };

        "Input",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:input", "Expression" >> }, Void
                            >> };

        "Output",         {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:output", "Expression" >> }, Void
                            >> };

        "Init",           {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:init", "Instruction*" >> }, Void
                            >> };

        "Transform",      {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:transform", "Instruction*" >> }, Void
                            >> };

        "Instruction*",   {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, agent build_empty_list(?);
                              {FAST_ARRAY[STRING] << "Instruction", "Instruction*" >> }, agent build_continue_list("Instruction", 0, ?)
                            >> };

        "Instruction",    {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "AssignOrCall" >> }, Void;
                              {FAST_ARRAY[STRING] << "Case" >> }, Void;
                              {FAST_ARRAY[STRING] << "If" >> }, Void;
                              {FAST_ARRAY[STRING] << "Skip" >> }, Void
                            >> };

        "AssignOrCall",   {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "Addressable", "AOCCont" >> }, Void
                            >> };

        "AOCCont",        {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW::=", "Expression" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:(", "Expression*", "KW:)" >> }, Void;
                            >> };

        "Case",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:case", "Expression", "When*", "Else", "KW:end" >> }, Void
                            >> };

        "If",            {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:if", "Then", "ElseIf*", "Else", "KW:end" >> }, Void
                            >> };

        "Skip",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:skip" >> }, Void
                            >> };

        "When*",         {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, agent build_empty_list(?);
                              {FAST_ARRAY[STRING] << "When", "When*" >> }, agent build_continue_list("When", 0, ?)
                            >> };

        "When",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:when", "Expression", "KW:then", "Instruction*" >> }, Void
                            >> };

        "Then",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "Expression", "KW:then", "Instruction*" >> }, Void
                            >> };

        "ElseIf*",       {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, agent build_empty_list(?);
                              {FAST_ARRAY[STRING] << "ElseIf", "ElseIf*" >> }, agent build_continue_list("ElseIf", 0, ?)
                            >> };

        "ElseIf",          {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:elseif", "Then" >> }, Void
                            >> };

        "Else",          {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:else", "Instruction*" >> }, Void
                            >> };

        "Expression*",   {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, agent build_empty_list(?);
                              {FAST_ARRAY[STRING] << "Expression" >> }, agent build_new_list("Expression", ?);
                              {FAST_ARRAY[STRING] << "Expression", "KW:,", "Expression*" >> }, agent build_continue_list("Expression", 1, ?)
                            >> };

        "Expression",    {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "BooleanOr" >> }, Void
                            >> };

        "BooleanOr",     {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "BooleanAnd", "BooleanOrR" >> }, Void;
                            >> };

        "BooleanOrR",    {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:or", "BooleanOr" >> }, Void;
                            >> };

        "BooleanAnd",    {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "BooleanComp", "BooleanAndR" >> }, Void;
                            >> };

        "BooleanAndR",   {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:and", "BooleanAnd" >> }, Void;
                            >> };

        "BooleanComp",   {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "ExpAdd", "BooleanCompR" >> }, Void;
                            >> };

        "BooleanCompR",  {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:=", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:/=", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:<", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:<=", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:>", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:>=", "ExpAdd" >> }, Void;
                            >> };

        "ExpAdd",        {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "ExpMult", "ExpAddR" >> }, Void;
                            >> };

        "ExpAddR",       {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:+", "ExpAdd" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:-", "ExpAdd" >> }, Void;
                            >> };

        "ExpMult",       {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "ExpPow", "ExpMultR" >> }, Void;
                            >> };

        "ExpMultR",      {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:*", "ExpMult" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:/", "ExpMult" >> }, Void;
                            >> };

        "ExpPow",        {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "ExpAtom", "ExpPowR" >> }, Void;
                            >> };

        "ExpPowR",       {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:^", "ExpPow" >> }, Void;
                            >> };

        "ExpAtom",       {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:value" >> }, Void;
                              {FAST_ARRAY[STRING] << "Addressable", "ExpCall" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:(", "Expression", "KW:)" >> }, Void;
                            >> };

        "ExpCall",       {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:(", "Expression*", "KW:)" >> }, Void;
                            >> };

        "ExpAtomR",      {DESCENDING_NON_TERMINAL
                            <<
                              epsilon, Void;
                              {FAST_ARRAY[STRING] << "KW:[", "Expression", "KW:]", "ExpAtomR" >> }, Void;
                              {FAST_ARRAY[STRING] << "KW:.", "Addressable" >> }, Void;
                            >> };

        "Addressable",   {DESCENDING_NON_TERMINAL
                            <<
                              {FAST_ARRAY[STRING] << "KW:identifier", "ExpAtomR" >> }, Void;
                            >> };

        -- Terminals

        "KW:value",      create {DESCENDING_TERMINAL}.make(agent parse_value(?), Void);
        "KW:identifier", create {DESCENDING_TERMINAL}.make(agent parse_identifier(?), Void);

        "KW:and",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "and"), Void);
        "KW:case",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "case"), Void);
        "KW:^",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "^"), Void);
        "KW:<=",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "<="), Void);
        "KW:<",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "<"), Void);
        "KW:=",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "="), Void);
        "KW:>=",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, ">="), Void);
        "KW:>",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, ">"), Void);
        "KW:-",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "-"), Void);
        "KW:,",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, ","), Void);
        "KW::=",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, ":="), Void);
        "KW:/=",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "/="), Void);
        "KW:/",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "/"), Void);
        "KW:.",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "."), Void);
        "KW:(",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "("), Void);
        "KW:)",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, ")"), Void);
        "KW:[",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "["), Void);
        "KW:]",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "]"), Void);
        "KW:*",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "*"), Void);
        "KW:+",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "+"), Void);
        "KW:else",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "else"), Void);
        "KW:elseif",     create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "elseif"), Void);
        "KW:end",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "end"), Void);
        "KW:if",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "if"), Void);
        "KW:init",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "init"), Void);
        "KW:input",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "input"), Void);
        "KW:or",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "or"), Void);
        "KW:output",     create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "output"), Void);
        "KW:skip",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "skip"), Void);
        "KW:then",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "then"), Void);
        "KW:transform",  create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "transform"), Void);
        "KW:when",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "when"), Void);

      >> }
      end

   table_memory: PARSE_TABLE[DESCENDING_PARSE_CONTEXT]

   is_keyword (a_string: STRING): BOOLEAN
      do
         inspect
            a_string
         when "and", "case", "else", "elseif", "end", "if", "init", "input", "or", "output", "skip", "then", "transform", "when" then
            Result := True
         else
            check not Result end
         end
      end

feature {ANY}
   table: PARSE_TABLE[DESCENDING_PARSE_CONTEXT]
      do
         Result := table_memory
         if Result = Void then
            Result := the_table
            Result.set_default_tree_builders(agent build_non_terminal(?, ?), agent build_terminal(?, ?))
            table_memory := Result
         end
      end

   root: MIXUP_TRANSFORM_NODE
      require
         has_root
      do
         Result := stack.first
      end

   has_root: BOOLEAN then error = Void and then not stack.is_empty and then stack.first.is_valid
      end

   error: STRING

feature {}
   epsilon: FAST_ARRAY[STRING]
      once
         create Result.with_capacity(0)
      end

   build_non_terminal (node_name: FIXED_STRING; node_content: TRAVERSABLE[FIXED_STRING])
      local
         i: INTEGER; new_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; node: MIXUP_TRANSFORM_NODE
      do
         log.trace.put_line("NT: #(1) => #(2)" # node_name # &node_content)
         if node_content.is_empty then
            create new_node.make_empty(node_name)
         else
            create new_node.make(node_name, node_content.count)
            from
               i := node_content.lower
            until
               i > node_content.upper
            loop
               node := stack.last
               stack.remove_last
               new_node.add_first(node)
               i := i + 1
            end
         end
         check
            new_node.is_valid
         end
         stack.add_last(new_node)
      end

   build_terminal (node_name: FIXED_STRING; node_image: PARSER_IMAGE)
      local
         image: MIXUP_TRANSFORM_NODE_IMAGE
         new_node: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         image ::= node_image
         log.trace.put_line("T: #(1)" # node_name)
         create new_node.make(node_name, image)
         stack.add_last(new_node)
      end

   build_empty_list (list_name: FIXED_STRING)
      local
         list: MIXUP_TRANSFORM_NODE_LIST
      do
         log.trace.put_line("L0: #(1)" # list_name)
         create list.make(list_name)
         stack.add_last(list)
      ensure
         stack.count = old stack.count + 1
         stack.last.name = list_name
      end

   build_new_list (atom_name: ABSTRACT_STRING; list_name: FIXED_STRING)
      require
         not stack.is_empty
         stack.last.name = atom_name.intern
      local
         atom: MIXUP_TRANSFORM_NODE; list: MIXUP_TRANSFORM_NODE_LIST
      do
         log.trace.put_line("L1: #(1)" # list_name)
         atom := stack.last
         check
            atom.name = atom_name.intern
         end
         stack.remove_last
         create list.make(list_name)
         list.add_first(atom)
         stack.add_last(list)
      ensure
         stack.count = old stack.count
         stack.last.name = list_name
      end

   build_continue_list (atom_name: ABSTRACT_STRING; forget: INTEGER; list_name: FIXED_STRING)
      require
         stack.count >= forget + 2
         stack.item(stack.upper).name = list_name
         stack.item(stack.upper - 1 - forget).name = atom_name.intern
      local
         atom: MIXUP_TRANSFORM_NODE; list: MIXUP_TRANSFORM_NODE_LIST; i: INTEGER
      do
         log.trace.put_line("L+: #(1)" # list_name)
         list ::= stack.last
         check
            list.name = list_name
         end
         stack.remove_last
         from
            i := 1
         until
            i > forget
         loop
            stack.remove_last
            i := i + 1
         end
         atom := stack.last
         check
            atom.name = atom_name.intern
         end
         stack.remove_last
         list.add_first(atom)
         stack.add_last(list)
      ensure
         stack.count = old stack.count - 1 - forget
         stack.last = old stack.last
         stack.last.name = list_name
      end

   parse_value (buffer: MINI_PARSER_BUFFER): MIXUP_TRANSFORM_NODE_IMAGE
      local
         start_index, start_position, end_position, string_state: INTEGER; image, string: STRING; value: INTEGER
      do
         start_index := buffer.current_index
         skip_blanks(buffer)
         if not buffer.end_reached then
            image := ""
            start_position := buffer.current_index
            inspect buffer.current_character
            when '0'..'9' then
               from
                  value := 0
               until
                  buffer.end_reached or else not buffer.current_character.is_digit
               loop
                  value := value * 10 + buffer.current_character.decimal_value
                  image.extend(buffer.current_character)
                  buffer.next
               end
               end_position := buffer.current_index
               create {MIXUP_TRANSFORM_NODE_IMAGE_TYPED[INTEGER]} Result.make(image, start_position, end_position, type_numeric, value)
            when '"' then
               from
                  string := ""
                  string_state := 0
                  image.extend(buffer.current_character)
                  buffer.next
               until
                  buffer.end_reached or else string_state < 0
               loop
                  image.extend(buffer.current_character)
                  inspect string_state
                  when 0 then
                     inspect buffer.current_character
                     when '\' then
                        string_state := 1
                     when '"' then
                        string_state := -1
                     else
                        string.extend(buffer.current_character)
                     end
                  when 1 then
                     string.extend(buffer.current_character)
                     string_state := 0
                  end
                  buffer.next
               end
               if string_state = -1 then
                  end_position := buffer.current_index
                  create {MIXUP_TRANSFORM_NODE_IMAGE_TYPED[STRING]} Result.make(image, start_position, end_position, type_string, string)
               else
                  error := "Unfinished string"
               end
            when '$' then
               image.extend(buffer.current_character)
               buffer.next
               if buffer.end_reached then
                  error := "Invalid argument index"
               else
                  from
                     value := 0
                  until
                     buffer.end_reached or else not buffer.current_character.is_digit
                  loop
                  value := value * 10 + buffer.current_character.decimal_value
                     image.extend(buffer.current_character)
                     buffer.next
                  end
                  end_position := buffer.current_index
                  if value = 0 then
                     error := "Invalid argument value"
                  else
                     create {MIXUP_TRANSFORM_NODE_IMAGE_TYPED[INTEGER]} Result.make(image, start_position, end_position, type_argument, value)
                  end
               end
            else
            end
         end
      end

   valid_identifier_start (c: CHARACTER): BOOLEAN
      do
         Result := c.is_letter
      end

   valid_identifier_part (c: CHARACTER): BOOLEAN
      do
         if c = '_' then
            Result := True
         else
            Result := c.is_letter_or_digit
         end
      end

   parse_identifier (buffer: MINI_PARSER_BUFFER): MIXUP_TRANSFORM_NODE_IMAGE
      local
         start_index, start_position, end_position: INTEGER; image: STRING
      do
         start_index := buffer.current_index
         skip_blanks(buffer)
         if not buffer.end_reached and then valid_identifier_start(buffer.current_character) then
            start_position := buffer.current_index
            from
               image := ""
            until
               buffer.end_reached or else not valid_identifier_part(buffer.current_character)
            loop
               image.extend(buffer.current_character)
               buffer.next
            end
            end_position := buffer.current_index
            if not is_keyword(image) then
               create {MIXUP_TRANSFORM_NODE_IMAGE_UNTYPED} Result.make(image, start_position, end_position)
            end
         end
      end

   parse_keyword (buffer: MINI_PARSER_BUFFER; keyword: STRING): MIXUP_TRANSFORM_NODE_IMAGE
      local
         start_index, start_position, end_position: INTEGER; image: STRING
      do
         start_index := buffer.current_index
         skip_blanks(buffer)
         if not buffer.end_reached then
            start_position := buffer.current_index
            image := keyword_image(buffer, keyword, Void)
            if image /= Void then
               end_position := buffer.current_index
               create {MIXUP_TRANSFORM_NODE_IMAGE_UNTYPED} Result.make(image, start_position, end_position)
            else
               buffer.set_current_index(start_index)
            end
         end
      end

   skip_blank (buffer: MINI_PARSER_BUFFER): BOOLEAN
      local
         start_index: INTEGER
      do
         if not buffer.end_reached then
            start_index := buffer.current_index
            if buffer.current_character.is_separator then
               buffer.next
               Result := True
            elseif buffer.current_character = '-' then
               buffer.next
               if buffer.current_character /= '-' then
                  buffer.set_current_index(start_index)
               else
                  Result := True
                  from
                     buffer.next
                  until
                     buffer.end_reached or else buffer.current_character = '%N'
                  loop
                     buffer.next
                  end
                  if not buffer.end_reached then
                     check
                        buffer.current_character = '%N'
                     end
                     buffer.next -- skip the '%N'
                  end
               end
            end
         end
      ensure
         not Result implies buffer.current_index = old buffer.current_index
      end

   skip_blanks (buffer: MINI_PARSER_BUFFER)
      do
         from
         until
            not skip_blank(buffer)
         loop
         end
         buffer.clear_mark
      ensure
         buffer.current_index >= old buffer.current_index
         not buffer.marked
      end

   keyword_image (buffer: MINI_PARSER_BUFFER; keyword, not_successors: STRING): STRING
      local
         start_index: INTEGER; i: INTEGER; c: CHARACTER
      do
         start_index := buffer.current_index
         from
            Result := keyword
            i := keyword.lower
         until
            i > keyword.upper or else Result = Void
         loop
            if buffer.end_reached or else buffer.current_character /= keyword.item(i) then
               buffer.set_current_index(start_index)
               Result := Void
            else
               buffer.next
               i := i + 1
            end
         end
         if not buffer.end_reached then
            c := buffer.current_character
            if not_successors = Void then
               if not c.is_separator and then keyword.first.is_letter_or_digit and then (c.is_letter_or_digit or else c = '_') then
                  Result := Void
                  buffer.set_current_index(start_index)
               end
            elseif not_successors.has(c) then
               Result := Void
               buffer.set_current_index(start_index)
            end
         end
      end

feature {}
   make
      do
         create stack
      end

   stack: FAST_ARRAY[MIXUP_TRANSFORM_NODE]

invariant
   stack /= Void

end -- class MIXUP_TRANSFORM_GRAMMAR

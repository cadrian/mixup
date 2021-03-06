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
class MIXUP_GRAMMAR

inherit
   MINI_PARSER_MEMORY
      rename
         memo as memo_save
         restore as memo_restore
         valid_memo as memo_is_valid
      redefine
         default_create
      end

insert
   MIXUP_NODE_HANDLER
      redefine
         default_create
      end
   PLATFORM
      redefine
         default_create
      end
   LOGGING
      redefine
         default_create
      end

create {ANY}
   with_factory, default_create

feature {ANY}
   end_reached: BOOLEAN
   parse_error: PARSE_ERROR

   parse (buffer: MINI_PARSER_BUFFER): BOOLEAN
      require
         buffer /= Void
      local
         parser: DESCENDING_PARSER
         old_memory: like memory
      do
         old_memory := memory
         create memory.make

         create parser.make
         buffer.set_memory(Current)
         Result := parser.eval(buffer, table, once "File")
         parse_error := parser.error

         memory := old_memory
      end

feature {}
   list_of (element_name: STRING; allow_empty: BOOLEAN; separator: STRING): PARSE_ATOM[DESCENDING_PARSE_CONTEXT]
      local
         list_name: STRING; accumulator_rule: TRAVERSABLE[STRING]; action: PROCEDURE[TUPLE[FIXED_STRING, TRAVERSABLE[FIXED_STRING]]]
      do
         if allow_empty then
            list_name := element_name + once "*"
         else
            list_name := element_name + once "+"
         end

         if separator = Void then
            accumulator_rule := {FAST_ARRAY[STRING] << element_name, list_name >> }
            action := agent build_continue_list(element_name, 0, list_name)
         else
            accumulator_rule := {FAST_ARRAY[STRING] << element_name, separator, list_name >> }
            action := agent build_continue_list(element_name, 1, list_name)
         end

         if allow_empty then
            if separator = Void then
               Result := {DESCENDING_NON_TERMINAL << epsilon, agent build_empty_list(list_name);
                                                     accumulator_rule, action;
                                                     >> }
            else
               Result := {DESCENDING_NON_TERMINAL << epsilon, agent build_empty_list(list_name);
                                                     {FAST_ARRAY[STRING] << separator >> }, agent build_empty_list(list_name);
                                                     {FAST_ARRAY[STRING] << element_name >> }, agent build_new_list(element_name, list_name);
                                                     accumulator_rule, action;
                                                     >> }
            end
         else
            Result := {DESCENDING_NON_TERMINAL << {FAST_ARRAY[STRING] << element_name >> }, agent build_new_list(element_name, list_name);
                                                  accumulator_rule, action;
                                                  >> }
         end
      end

   the_table: PARSE_TABLE[DESCENDING_PARSE_CONTEXT]
      local
         e1, e2, e3, e4, e5, e6: FIXED_STRING
      once
         e1 := "e1".intern
         e2 := "e2".intern
         e3 := "e3".intern
         e4 := "e4".intern
         e5 := "e5".intern
         e6 := "e6".intern

         Result := {PARSE_TABLE[DESCENDING_PARSE_CONTEXT] <<
                                   "File", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "File_Content", "KW end", "KW end of file" >> }, Void;
                                      >> };
                                   "File_Content", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Score" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Book" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Partitur" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Instrument" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Module" >> }, Void;
                                      >> };

                                   "Module", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW module", "KW identifier", "Definition*" >> }, Void;
                                      >> };

                                   "Score", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW score", "KW identifier", "Score_Content" >> }, Void;
                                      >> };

                                   "Score_Content", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Definition*", "Book*" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Book_Content" >> }, Void;
                                      >> };

                                   "Definition*", list_of("Definition", True, Void);

                                   "Definition", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Export" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Import" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Set" >> }, Void;
                                      >> };

                                   "Export", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW export", "Identifier", "KW :=", "Value_Or_Tuple" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW export", "KW const", "Identifier", "KW :=", "Value_Or_Tuple" >> }, Void;
                                      >> };

                                   "Set", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW set", "Identifier", "KW :=", "Value_Or_Tuple" >> }, Void;
                                      >> };

                                   "Import", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW from", "Identifier", "KW import", "Identifier+" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW from", "Identifier", "KW import", "KW *" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW import", "Identifier" >> }, Void;
                                      >> };

                                   "Identifier+", list_of("Identifier", False, "KW ,");

                                   "Book*", list_of("Book", True, Void);

                                   "Book", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW book", "KW identifier", "Book_Content" >> }, Void;
                                      >> };

                                   "Book_Content", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Definition*", "Partitur*" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Partitur_Content" >> }, Void;
                                      >> };

                                   "Partitur*", list_of("Partitur", True, Void);

                                   "Partitur", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW partitur", "KW identifier", "Partitur_Content" >> }, Void;
                                      >> };

                                   "Partitur_Content", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Definition*", "Instrument*" >> }, Void;
                                      >> };

                                   "Instrument*", list_of("Instrument", True, Void);

                                   "Instrument", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW instrument", "KW identifier", "Definition*", "Some_Music", "KW end" >> }, Void;
                                      >> };

                                   "Some_Music", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "Identifier", "Some_Lyrics" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Music", "Some_Lyrics" >> }, Void;
                                      >> };

                                   "Some_Lyrics", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "Identifier" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Lyrics" >> }, Void;
                                      >> };

                                   "Value_Or_Tuple", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Value" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Value_Tuple" >> }, Void;
                                      >> };

                                   "Value", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW number" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW boolean" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW Result" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Open_Argument" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Identifier" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Music_Value" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Lyrics" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Function" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Agent" >> }, Void;
                                      >> };

                                   "Value_Tuple", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW [", "Value*", "KW ]" >> }, Void;
                                      >> };

                                   "Value*", list_of("Value", True, "KW ,");

                                   "Agent", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW '", "Identifier" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW '", "Function", "Identifier_Args" >> }, Void;
                                      >> };

                                   "Open_Argument", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW ?" >> }, Void;
                                      >> };

                                   "Identifier", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Identifier_Part" >> }, agent build_new_list("Identifier_Part", "Identifier");
                                      {FAST_ARRAY[STRING] << "Identifier_Part", "KW .", "Identifier" >> }, agent build_continue_list("Identifier_Part", 1, "Identifier")
                                      >> };

                                   "Identifier_Part", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW identifier", "Identifier_Args" >> }, Void;
                                      >> };

                                   "Identifier_Args", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW (", "Expression*", "KW )" >> }, Void;
                                      >> };

                                   "Lyrics", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW lyrics", "Strophe*" >> }, Void;
                                      >> };

                                   "Strophe*", list_of("Strophe", True, Void);

                                   "Strophe", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW <<", "Word*", "KW >>" >> }, Void;
                                      >> };

                                   "Word*", list_of("Word", True, Void);

                                   "Word", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Syllable+" >> }, Void;
                                      >> };

                                   "Syllable+", list_of("Syllable", False, "KW -");

                                   "Syllable", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW syllable" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Extern_Syllable" >> }, Void;
                                      >> };

                                   "Extern_Syllable", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW \", "Identifier" >> }, Void;
                                      >> };

                                   "Music", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW music", "Staff+" >> }, Void;
                                      >> };

                                   "Music_Value", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW music", "Voices" >> }, Void;
                                      >> };

                                   "Notes*", list_of("Notes", True, Void);

                                   "Notes", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Next_Bar" >> }, Void; -- check bar
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Extern_Notes" >> }, Void; -- music insertion
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Voices" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Chord_Or_Tie" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Beam" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Phrasing_Slur" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamics*", "Slur" >> }, Void;
                                      >> };

                                   "Next_Bar", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW |" >> }, Void;
                                      >> };

                                   "Extern_Notes", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW \", "Identifier" >> }, Void;
                                      >> };

                                   "Chord_Or_Tie", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Chord" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Chord", "KW ~" >> }, Void;
                                      >> };

                                   "Chord", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW <", "Note_Head+", "KW >", "Note_Length" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Note_Head", "Note_Length" >> }, Void;
                                      >> };

                                   "Note_Head+", list_of("Note_Head", False, Void);

                                   "Note_Head",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW note head" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW '" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW '", "KW '" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW '", "KW '", "KW '" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW ," >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW ,", "KW ," >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW note head", "KW ,", "KW ,", "KW ," >> }, Void;
                                      >> };

                                   "Note_Length", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW number" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW number", "Dot" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW number", "DotDot" >> }, Void;
                                      >> };

                                   "Dot", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW ." >> }, Void;
                                      >> };

                                   "DotDot", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW .." >> }, Void;
                                      >> };

                                   "Dynamics*", list_of("Dynamics", True, Void);

                                   "Dynamics", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW :", "Position", "Dynamic+", "KW :" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW :", "Position", "Dynamic+", "KW ...", "KW :" >> }, Void; -- dashed line along the whole dynamic section (not with hairpins!)
                                      >> };

                                   "Dynamic+", list_of("Dynamic", False, "KW ,");

                                   "Dynamic",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Dynamic_Identifier" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamic_String" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamic_Hairpin_Crescendo" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamic_Hairpin_Decrescendo" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dynamic_End" >> }, Void; -- end of dynamic (stop hairpin, etc.)
                                      >> };

                                   "Dynamic_Identifier",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW identifier" >> }, Void;
                                      >> };

                                   "Dynamic_String",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                      >> };

                                   "Dynamic_Hairpin_Crescendo",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW <" >> }, Void;
                                      >> };

                                   "Dynamic_Hairpin_Decrescendo",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW >" >> }, Void;
                                      >> };

                                   "Dynamic_End",  {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW end" >> }, Void; -- end of dynamic (stop hairpin, etc.)
                                      >> };

                                   "Position", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW up", "KW :" >> }, Void; -- up current staff
                                      {FAST_ARRAY[STRING] << "KW down", "KW :" >> }, Void; -- down current staff
                                      {FAST_ARRAY[STRING] << "KW top", "KW :" >> }, Void; -- up current instrument
                                      {FAST_ARRAY[STRING] << "KW bottom", "KW :" >> }, Void; -- down current instrument
                                      {FAST_ARRAY[STRING] << "KW hidden", "KW :" >> }, Void; -- don't display, e.g. for midi control only
                                      >> };

                                   "Staff+", list_of("Staff", False, Void);

                                   "Staff", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Voices" >> }, Void;
                                      >> };

                                   "Voices", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW <<", "Voice+", "KW >>" >> }, Void;
                                      >> };

                                   "Voice+", list_of("Voice", False, "KW //");

                                   "Voice", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Notes*" >> }, Void;
                                      >> };

                                   "Beam", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW [", "Xuplet_Spec", "Notes*", "KW ]" >> }, Void;
                                      >> };

                                   "Phrasing_Slur", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW {", "Xuplet_Spec", "Notes*", "KW }" >> }, Void;
                                      >> };

                                   "Slur", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW (", "Xuplet_Spec", "Notes*", "KW )" >> }, Void;
                                      >> };

                                   "Xuplet_Spec", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW number", "KW /", "KW number" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW number", "KW /", "KW number", "KW string" >> }, Void;
                                      >> };

                                   "Function", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW function", "Signature", "Function_Body" >> }, Void;
                                      >> };

                                   "Signature", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW (", "Arg+", "KW )" >> }, Void;
                                      >> };

                                   "Arg+", list_of("Arg", False, "KW ,");

                                   "Arg", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW identifier" >> }, Void;
                                      >> };

                                   "Function_Body", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Function_Native" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Function_User" >> }, Void;
                                      >> };

                                   "Function_Native", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW native", "KW string" >> }, Void;
                                      >> };

                                   "Function_User", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW do", "Statement*", "KW end" >> }, Void;
                                      >> };

                                   "Statement*", list_of("Statement", True, Void);

                                   "Statement", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "If_Then_Else" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Inspect" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Loop" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Expression_Or_Assignment" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Yield" >> }, Void;
                                      >> };

                                   "Yield", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW yield", "Expression" >> }, Void;
                                      >> };

                                   "Expression_Or_Assignment", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Expression", "KW :=", "Expression" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Expression" >> }, Void;
                                      >> };

                                   "Loop", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW for", "KW identifier", "KW in", "Expression", "KW do", "Statement*", "KW end" >> }, Void;
                                      >> };

                                   "If_Then_Else", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "If", "ElseIf*", "Else", "KW end" >> }, Void;
                                      >> };

                                   "If", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW if", "Expression", "KW then", "Statement*" >> }, Void;
                                      >> };

                                   "ElseIf*", list_of("ElseIf", True, Void);

                                   "ElseIf", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW elseif", "Expression", "KW then", "Statement*" >> }, Void;
                                      >> };

                                   "Else", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW else", "Statement*" >> }, Void;
                                      >> };

                                   "Inspect", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW inspect", "Unary_Expression", "Inspect_Branch+", "Else", "KW end" >> }, Void;
                                      >> };

                                   "Inspect_Branch+", list_of("Inspect_Branch", False, Void);

                                   "Inspect_Branch", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW when", "Expression", "KW then", "Statement*" >> }, Void;
                                      >> };

                                   "Expression", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Collection" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Unary_Expression" >> }, Void;
                                      >> };

                                   "Unary_Expression", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e1", "r1" >> }, agent build_unary_expression(e1, ?);
                                      >> };

                                   "e1", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e2", "r2" >> }, agent build_expression(e2);
                                      >> };

                                   "e2", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e3", "r3" >> }, agent build_expression(e3);
                                      >> };

                                   "e3", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e4", "r4" >> }, agent build_expression(e4);
                                      >> };

                                   "e4", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e5", "r5" >> }, agent build_expression(e5);
                                      >> };

                                   "e5", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e6", "r6" >> }, agent build_expression(e6);
                                      >> };

                                   "e6", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "e7", "r7" >> }, Void;
                                      >> };

                                   "e7", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW not", "e7" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW +", "e7" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW -", "e7" >> }, Void;
                                      {FAST_ARRAY[STRING] << "e8" >> }, Void;
                                      >> };

                                   "e8", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Value" >> }, Void;
                                      {FAST_ARRAY[STRING] << "KW (", "Unary_Expression", "KW )" >> }, Void;
                                      >> };

                                   "r1", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_epsilon(e1);
                                      {FAST_ARRAY[STRING] << "KW implies", "e1", "r1" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW implies" >> }, e1);
                                      >> };

                                   "r2", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_epsilon(e2);
                                      {FAST_ARRAY[STRING] << "KW or", "e2", "r2" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW or" >> }, e2);
                                      {FAST_ARRAY[STRING] << "KW xor", "e2", "r2" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW xor" >> }, e2);
                                      >> };

                                   "r3", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_epsilon(e3);
                                      {FAST_ARRAY[STRING] << "KW and", "e3", "r3" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW and" >> }, e3);
                                      >> };

                                   "r4", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_epsilon(e4);
                                      {FAST_ARRAY[STRING] << "KW =", "e4", "r4" >> },  agent build_expression_remainder({FAST_ARRAY[STRING] << "KW ="  >> }, e4 );
                                      {FAST_ARRAY[STRING] << "KW !=", "e4", "r4" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW /=" >> }, e4 );
                                      {FAST_ARRAY[STRING] << "KW <=", "e4", "r4" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW <=" >> }, e4 );
                                      {FAST_ARRAY[STRING] << "KW <", "e4", "r4" >> },  agent build_expression_remainder({FAST_ARRAY[STRING] << "KW <"  >> }, e4 );
                                      {FAST_ARRAY[STRING] << "KW >=", "e4", "r4" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW >=" >> }, e4 );
                                      {FAST_ARRAY[STRING] << "KW >", "e4", "r4" >> },  agent build_expression_remainder({FAST_ARRAY[STRING] << "KW >"  >> }, e4 );
                                      >> };

                                   "r5", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_epsilon(e5);
                                      {FAST_ARRAY[STRING] << "KW +", "e5", "r5" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW +" >> }, e5 );
                                      {FAST_ARRAY[STRING] << "KW -", "e5", "r5" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW -" >> }, e5 );
                                      >> };

                                   "r6", {DESCENDING_NON_TERMINAL <<
                                      epsilon, agent build_expression_e6;
                                      {FAST_ARRAY[STRING] << "KW *", "e6", "r6" >> },  agent build_expression_remainder({FAST_ARRAY[STRING] << "KW *"  >> }, e6 );
                                      {FAST_ARRAY[STRING] << "KW /", "e6", "r6" >> },  agent build_expression_remainder({FAST_ARRAY[STRING] << "KW /"  >> }, e6 );
                                      {FAST_ARRAY[STRING] << "KW //", "e6", "r6" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW //" >> }, e6 );
                                      {FAST_ARRAY[STRING] << "KW \\", "e6", "r6" >> }, agent build_expression_remainder({FAST_ARRAY[STRING] << "KW \\" >> }, e6 );
                                      >> };

                                   "r7", {DESCENDING_NON_TERMINAL <<
                                      epsilon, Void;
                                      {FAST_ARRAY[STRING] << "KW ^", "e7", "r7" >> }, Void;
                                      >> };

                                   "Collection", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "List" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Dictionary" >> }, Void;
                                      {FAST_ARRAY[STRING] << "Tuple" >> }, Void;
                                      >> };

                                   "List", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW <<", "Expression*", "KW >>" >> }, Void;
                                      >> };

                                   "Tuple", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW [", "Expression*", "KW ]" >> }, Void;
                                      >> };

                                   "Dictionary", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "KW {", "Expression_Pair*", "KW }" >> }, Void;
                                      >> };

                                   "Expression*", list_of("Expression", True, "KW ,");

                                   "Expression_Pair*", list_of("Expression_Pair", True, "KW ,");

                                   "Expression_Pair", {DESCENDING_NON_TERMINAL <<
                                      {FAST_ARRAY[STRING] << "Expression", "KW :", "Expression" >> }, Void;
                                      >> };


                                   "KW ^",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "^" , ""),      Void);
                                   "KW ~",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "~" , ""),      Void);
                                   "KW <<",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "<<", ""),      Void);
                                   "KW <=",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "<=", ""),      Void);
                                   "KW <",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "<" , "<="),    Void);
                                   "KW =",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "=" , ""),      Void);
                                   "KW >=",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ">=", ""),      Void);
                                   "KW >>",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ">>", ""),      Void);
                                   "KW >",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ">" , ">="),    Void);
                                   "KW |",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "|" , ""),      Void);
                                   "KW -",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "-" , ""),      Void);
                                   "KW ,",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "," , ""),      Void);
                                   "KW :=",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ":=" , ""),     Void);
                                   "KW :",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ":" , "="),     Void);
                                   "KW !=",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "!=" , ""),     Void);
                                   "KW ?",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "?" , ""),      Void);
                                   "KW //",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "//" , ""),     Void);
                                   "KW /",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "/" , "/"),     Void);
                                   "KW ...",         create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "..." , ""),    Void);
                                   "KW ..",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ".." , "."),    Void);
                                   "KW .",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "." , "."),     Void);
                                   "KW '",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "'" , ""),      Void);
                                   "KW (",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "(" , ""),      Void);
                                   "KW )",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, ")" , ""),      Void);
                                   "KW [",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "[" , ""),      Void);
                                   "KW ]",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "]" , ""),      Void);
                                   "KW {",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "{" , ""),      Void);
                                   "KW }",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "}" , ""),      Void);
                                   "KW *",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "*" , ""),      Void);
                                   "KW \",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "\" , "\"),     Void);
                                   "KW \\",          create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "\\" , ""),     Void);
                                   "KW +",           create {DESCENDING_TERMINAL}.make(agent parse_symbol(?, "+" , ""),      Void);

                                   "KW and",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "and"),        Void);
                                   "KW book",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "book"),       Void);
                                   "KW bottom",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "bottom"),     Void);
                                   "KW const",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "const"),      Void);
                                   "KW do",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "do"),         Void);
                                   "KW down",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "down"),       Void);
                                   "KW else",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "else"),       Void);
                                   "KW elseif",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "elseif"),     Void);
                                   "KW end",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "end"),        Void);
                                   "KW export",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "export"),     Void);
                                   "KW for",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "for"),        Void);
                                   "KW from",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "from"),       Void);
                                   "KW function",    create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "function"),   Void);
                                   "KW hidden",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "hidden"),     Void);
                                   "KW if",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "if"),         Void);
                                   "KW implies",     create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "implies"),    Void);
                                   "KW import",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "import"),     Void);
                                   "KW in",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "in"),         Void);
                                   "KW inspect",     create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "inspect"),    Void);
                                   "KW instrument",  create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "instrument"), Void);
                                   "KW lyrics",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "lyrics"),     Void);
                                   "KW module",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "module"),     Void);
                                   "KW music",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "music"),      Void);
                                   "KW native",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "native"),     Void);
                                   "KW not",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "not"),        Void);
                                   "KW or",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "or"),         Void);
                                   "KW partitur",    create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "partitur"),   Void);
                                   "KW Result",      create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "Result"),     Void);
                                   "KW score",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "score"),      Void);
                                   "KW set",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "set"),        Void);
                                   "KW then",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "then"),       Void);
                                   "KW top",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "top"),        Void);
                                   "KW up",          create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "up"),         Void);
                                   "KW when",        create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "when"),       Void);
                                   "KW xor",         create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "xor"),        Void);
                                   "KW yield",       create {DESCENDING_TERMINAL}.make(agent parse_keyword(?, "yield"),      Void);

                                   "KW boolean",     create {DESCENDING_TERMINAL}.make(agent parse_boolean,                  Void);
                                   "KW identifier",  create {DESCENDING_TERMINAL}.make(agent parse_identifier,               Void);
                                   "KW note head",   create {DESCENDING_TERMINAL}.make(agent parse_note_head,                Void);
                                   "KW number",      create {DESCENDING_TERMINAL}.make(agent parse_number,                   Void);
                                   "KW string",      create {DESCENDING_TERMINAL}.make(agent parse_string,                   Void);
                                   "KW syllable",    create {DESCENDING_TERMINAL}.make(agent parse_syllable,                 Void);

                                   "KW end of file", create {DESCENDING_TERMINAL}.make(agent parse_end,                      Void);

                                   >> }
      end

   table_memory: PARSE_TABLE[DESCENDING_PARSE_CONTEXT]

feature {ANY}
   table: PARSE_TABLE[DESCENDING_PARSE_CONTEXT]
      do
         Result := table_memory
         if Result = Void then
            Result := the_table
            Result.set_default_tree_builders(agent build_non_terminal, agent build_terminal)
            table_memory := Result
         end
      end

   display (output: OUTPUT_STREAM)
      do
         if not stack.is_empty then
            stack.first.display(output, 0, Void)
         end
      end

   generate (o: OUTPUT_STREAM)
      do
         if not stack.is_empty then
            stack.first.generate(o)
         end
      end

   root_node: MIXUP_NODE
      do
         if not stack.is_empty then
            Result := stack.first
         end
      end

   reset
      do
         stack.clear_count
         create position
         end_reached := False
      ensure
         stack.is_empty
         not end_reached
      end

feature {}
   epsilon: FAST_ARRAY[STRING]
      once
         create Result.with_capacity(0)
      end

   last_blanks: STRING is ""
   comment_position: like position
   has_comment: BOOLEAN

   skip_blank (buffer: MINI_PARSER_BUFFER; skip_semi_colons: BOOLEAN): BOOLEAN
      local
         old_position: like position
      do
         if not buffer.end_reached then
            old_position := position
            if buffer.current_character.is_separator then
               last_blanks.extend(buffer.current_character)
               next_character(buffer)
               Result := True
            elseif skip_semi_colons and then buffer.current_character = ';' then
               last_blanks.extend(buffer.current_character)
               next_character(buffer)
               Result := True
            elseif buffer.current_character = '-' then
               next_character(buffer)
               if buffer.current_character /= '-' then
                  restore(buffer, old_position)
               else
                  Result := True
                  if not has_comment then
                     comment_position := position
                     has_comment := True
                  end
                  last_blanks.extend('-')
                  last_blanks.extend('-')
                  from
                     next_character(buffer)
                  until
                     buffer.end_reached or else buffer.current_character = '%N'
                  loop
                     last_blanks.extend(buffer.current_character)
                     next_character(buffer)
                  end
                  if not buffer.end_reached then
                     check
                        buffer.current_character = '%N'
                     end
                     last_blanks.extend('%N')
                     next_character(buffer) -- skip the '%N'
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
            has_comment := False
            last_blanks.clear_count
         until
            not skip_blank(buffer, False)
         loop
         end
         buffer.clear_mark
      ensure
         buffer.current_index = last_blanks.count + old buffer.current_index
         not buffer.marked
      end

   parse_end (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE
      local
         old_position: like position
      do
         old_position := position
         skip_blanks(buffer)
         if buffer.end_reached then
            create Result.make(once "", last_blanks.twin, position)
         else
            restore(buffer, old_position)
         end
      end

   parse_string (buffer: MINI_PARSER_BUFFER): TYPED_MIXUP_IMAGE[STRING]
         -- the algorithm is a bit less strict than SmartMixup's
      local
         old_position, start_position: like position; i, t, state, code, scale: INTEGER; c: CHARACTER; image, parsed, end_tag: STRING; unicode: BOOLEAN
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         if not buffer.end_reached and then buffer.current_character = 'U' then
            image := once ""
            image.copy(once "U")
            next_character(buffer)
            if buffer.end_reached or else buffer.current_character /= '"' then
               image := Void
            end
         end
         if not buffer.end_reached and then buffer.current_character = '"' then
            if image = Void then
               image := once ""
               image.clear_count
            end
            parsed := once ""
            parsed.clear_count
            image.extend('"')
            from
               next_character(buffer)
            until
               state < 0 or else buffer.end_reached
            loop
               c := buffer.current_character
               inspect state
               when 0 then
                  -- normal simple string state
                  inspect
                     c
                  when '"' then
                     image.extend('"')
                     state := -1
                  when '%%' then
                     image.extend('%%')
                     state := 1
                  when '[' then
                     image.extend('[')
                     state := 10
                  when '{' then
                     image.extend('{')
                     state := 11
                  when '%N', '%R' then
                     image := Void
                     state := -1
                  else
                     image.extend(c)
                     parsed.extend(c)
                  end
               when 1 then
                  -- just after a % in a simple string
                  inspect
                     c
                  when '%R' then
                     parsed.extend('%R')
                     image.extend(c)
                     state := 2
                  when '%N' then
                     parsed.extend('%N')
                     image.extend(c)
                     state := 2
                  when 'A' then
                     parsed.extend('%A')
                     image.extend(c)
                     state := 0
                  when 'B' then
                     parsed.extend('%B')
                     image.extend(c)
                     state := 0
                  when 'C' then
                     parsed.extend('%C')
                     image.extend(c)
                     state := 0
                  when 'D' then
                     parsed.extend('%D')
                     image.extend(c)
                     state := 0
                  when 'F' then
                     parsed.extend('%F')
                     image.extend(c)
                     state := 0
                  when 'H' then
                     parsed.extend('%H')
                     image.extend(c)
                     state := 0
                  when 'L' then
                     parsed.extend('%L')
                     image.extend(c)
                     state := 0
                  when 'N' then
                     parsed.extend('%N')
                     image.extend(c)
                     state := 0
                  when 'Q' then
                     parsed.extend('%Q')
                     image.extend(c)
                     state := 0
                  when 'R' then
                     parsed.extend('%R')
                     image.extend(c)
                     state := 0
                  when 'S' then
                     parsed.extend('%S')
                     image.extend(c)
                     state := 0
                  when 'T' then
                     parsed.extend('%T')
                     image.extend(c)
                     state := 0
                  when 'U' then
                     parsed.extend('%U')
                     image.extend(c)
                     state := 0
                  when 'V' then
                     parsed.extend('%V')
                     image.extend(c)
                     state := 0
                  when '%%' then
                     parsed.extend('%%')
                     image.extend(c)
                     state := 0
                  when '%'' then
                     parsed.extend('%'')
                     image.extend(c)
                     state := 0
                  when '%"' then
                     parsed.extend('%"')
                     image.extend(c)
                     state := 0
                  when '(' then
                     parsed.extend('%(')
                     image.extend(c)
                     state := 0
                  when ')' then
                     parsed.extend('%)')
                     image.extend(c)
                     state := 0
                  when '<' then
                     parsed.extend('%<')
                     image.extend(c)
                     state := 0
                  when '>' then
                     parsed.extend('%>')
                     image.extend(c)
                     state := 0
                  when '/' then
                     image.extend(c)
                     code := 0
                     scale := 10
                     unicode := False
                     state := 3
                  else
                     -- unknown escape character
                     image := Void
                     state := -1
                  end
               when 2 then
                  inspect
                     c
                  when '%R', '%N', '%T', ' ' then
                     parsed.extend(c)
                     image.extend(c)
                  when '%%' then
                     image.extend(c)
                     state := 0
                  else
                     image := Void
                     state := -1
                  end
               when 3 then
                  inspect c
                  when '0'..'9' then
                     code := code * scale + (c.code - '0'.code)
                     image.extend(c)
                  when 'A'..'F' then
                     if scale = 16 then
                        code := code * scale + (c.code - 'A'.code + 10)
                        image.extend(c)
                     else
                        image := Void
                        state := -1
                     end
                  when 'a'..'f' then
                     if scale = 16 then
                        code := code * scale + (c.code - 'a'.code + 10)
                        image.extend(c)
                     else
                        image := Void
                        state := -1
                     end
                  when 'x' then
                     scale := 16
                     image.extend(c)
                  when 'U' then
                     scale := 16
                     unicode := True
                     image.extend(c)
                  when '/' then
                     if unicode then
                        -- parsed.extend(code.to_unicode_character) -- *** TODO unicode
                     else
                        parsed.extend(code.to_character)
                     end
                     image.extend('/')
                     state := 0
                  else
                     image := Void
                     state := -1
                  end
               when 10 then
                  -- maybe the start of a multi-line "[...]" string?
                  check
                     end_tag = Void
                     image.count >= 2
                  end
                  inspect
                     c
                  when '%N', '%R' then
                     end_tag := once ""
                     end_tag.copy(image)
                     end_tag.put(']', end_tag.lower)
                     end_tag.put('"', end_tag.upper)
                     image.extend(c)
                     state := 12
                     t := end_tag.lower
                  when '%%' then
                     parsed.extend('[')
                     image.extend('[')
                     image.extend('%%')
                     state := 1
                  when '"' then
                     parsed.extend('[')
                     image.extend('[')
                     image.extend('"')
                     state := -1
                  else
                     parsed.extend('[')
                     parsed.extend(c)
                     image.extend(c)
                     state := 0
                  end
               when 11 then
                  -- maybe the start of a multi-line "{...}" string?
                  check
                     end_tag = Void
                     image.count >= 2
                  end
                  inspect
                     c
                  when '%N', '%R' then
                     end_tag := once ""
                     end_tag.copy(image)
                     end_tag.put('}', end_tag.lower)
                     end_tag.put('"', end_tag.upper)
                     image.extend(c)
                     state := 12
                     t := end_tag.lower
                  when '%%' then
                     parsed.extend('{')
                     image.extend('{')
                     image.extend('%%')
                     state := 1
                  when '"' then
                     parsed.extend('{')
                     image.extend('{')
                     image.extend('"')
                     state := -1
                  else
                     parsed.extend('{')
                     parsed.extend(c)
                     image.extend(c)
                     state := 0
                  end
               when 12 then
                  -- in a multi-line string
                  check
                     end_tag.count >= 2
                     end_tag.valid_index(t)
                  end
                  inspect
                     c
                  when '"' then
                     image.extend('"')
                     if t = end_tag.upper then
                        -- check that the beginning of the line contains only spaces
                        from
                           i := image.upper - end_tag.count
                           check
                              image.count > 2 * end_tag.count
                              i > end_tag.count
                           end
                        until
                           state = -1 or else i < end_tag.count
                        loop
                           inspect
                              image.item(i)
                           when '%R', '%N' then
                              -- we found the end tag
                              state := -1
                           when ' ', '%T' then
                              -- still checking
                              i := i - 1
                           else
                              -- not the end of the string yet because the end tag is not alone on the line (except for leading spaces)
                              i := 0
                           end
                        end
                     else
                        parsed.extend('"')
                     end
                     t := end_tag.lower
                  else
                     if c = end_tag.item(t) then
                        t := t + 1
                     else
                        if t > end_tag.lower then
                           parsed.append(end_tag.substring(end_tag.lower, t - 1))
                           t := end_tag.lower
                        end
                        parsed.extend(c)
                     end
                     image.extend(c)
                  end
               end
               next_character(buffer)
            end
            if image /= Void then
               create Result.make(image.twin, parsed.twin, last_blanks.twin, start_position)
            else
               restore(buffer, old_position)
            end
         end
      ensure
         Result /= Void implies (
               (Result.image.count >= 2 and then Result.image.first = '"')
                  or else
               (Result.image.count >= 3 and then Result.image.first = 'U' and then Result.image.item(2) = '"')
            ) and then Result.image.last = '"'
      end

   parse_number (buffer: MINI_PARSER_BUFFER): MIXUP_IMAGE
      local
         old_position, start_position, cur_position: like position; state: INTEGER; c: CHARACTER; image: STRING
         valid, valid_before_dot, valid_before_exp: BOOLEAN
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         if not buffer.end_reached then
            image := once ""
            image.clear_count
            from
               c := buffer.current_character
               image.extend(c)
               next_character(buffer)
               inspect c
               when '+', '-' then
                  c := buffer.current_character
                  image.extend(c)
                  inspect c
                  when '0' then
                     valid := True
                     state := 1
                  when '1' .. '9' then
                     valid := True
                     -- state := 0
                  else
                     state := -1
                  end
                  next_character(buffer)
               when '.' then
                  -- state := 0
               when '0' then
                  valid := True
                  state := 1
               when '1'..'9' then
                  valid := True
                  -- state := 0
               else
                  image := Void
                  state := -1
               end
               cur_position := position
            until
               buffer.end_reached or else state < 0
            loop
               c := buffer.current_character
               inspect
                  state
               when 0 then
                  -- decimal integer
                  inspect
                     c
                  when '_' then
                     image.extend(c)
                  when '0' .. '9' then
                     image.extend(c)
                     valid := True
                  when '.' then
                     image.extend(c)
                     valid_before_dot := valid
                     valid := False
                     state := 3
                  when 'e', 'E' then
                     image.extend(c)
                     valid_before_exp := valid
                     valid := False
                     state := 4
                  else
                     state := -1
                  end
               when 1 then
                  -- first character was zero; just read the second.
                  inspect
                     c
                  when 'x', 'X' then
                     image.extend(c)
                     valid := False
                     state := 2
                  when '_' then
                     image.extend(c)
                     state := 0
                  when '0' .. '9' then
                     image.extend(c)
                     valid := True
                     state := 0
                  when '.' then
                     image.extend(c)
                     valid_before_dot := valid
                     valid := False
                     state := 3
                  else
                     state := -1
                  end
               when 2 then
                  -- hexadecimal integer
                  inspect
                     c
                  when '0' .. '9', '_', 'A' .. 'F', 'a' .. 'f' then
                     image.extend(c)
                     valid := True
                  else
                     state := -1
                  end
               when 3 then
                  -- fractional part
                  inspect
                     c
                  when '_' then
                     image.extend(c)
                  when '0' .. '9' then
                     image.extend(c)
                     valid := True
                  when 'e', 'E' then
                     image.extend(c)
                     valid_before_exp := valid
                     valid := False
                     state := 4
                  else
                     if image.last = '.' then
                        image.remove_last
                        restore(buffer, cur_position)
                        valid := valid_before_dot
                     end
                     state := -1
                  end
               when 4 then
                  -- just read the 'e' of the exponential part
                  check not valid end
                  inspect
                     c
                  when '+', '-' then
                     image.extend(c)
                     state := 5
                  when '0' .. '9' then
                     image.extend(c)
                     valid := True
                     state := 5
                  else
                     image.remove_last
                     restore(buffer, cur_position)
                     valid := valid_before_exp
                     state := -1
                  end
               when 5 then
                  -- exponential part
                  inspect
                     c
                  when '_' then
                     image.extend(c)
                  when '0' .. '9' then
                     image.extend(c)
                     valid := True
                  else
                     state := -1
                  end
               end
               if state >= 0 then
                  cur_position := position
                  next_character(buffer)
               end
            end
            if not valid or (not buffer.end_reached and then buffer.current_character.is_letter) then
               image := Void
            end
         end
         if image = Void then
            restore(buffer, old_position)
         elseif image.is_integer_64 then
            create {TYPED_MIXUP_IMAGE[INTEGER_64]}Result.make(image.twin, image.to_integer_64, last_blanks.twin, start_position)
         elseif is_hex(image) then
            create {TYPED_MIXUP_IMAGE[INTEGER_64]}Result.make(image.twin, hex_to_integer_64(image), last_blanks.twin, start_position)
         elseif image.is_real then
            create {TYPED_MIXUP_IMAGE[REAL]}Result.make(image.twin, image.to_real, last_blanks.twin, start_position)
         else
            create {UNTYPED_MIXUP_IMAGE}Result.make(image.twin, last_blanks.twin, start_position)
         end
      end

   is_hex (image: STRING): BOOLEAN
      local
         i: INTEGER
      do
         from
            Result := image.count.in_range(3, 18) and then image.has_prefix(once "0x")
            i := 3
         until
            not Result or else i > image.count
         loop
            inspect
               image.item(i)
            when '0'..'9', 'a'..'f', 'A'..'F' then
               check Result end
            else
               Result := False
            end
            i := i + 1
         end
      end

   hex_to_integer_64 (image: STRING): INTEGER_64
      require
         is_hex(image)
      local
         i, n: INTEGER; c: CHARACTER
      do
         from
            i := 3
         until
            i > image.count
         loop
            c := image.item(i)
            inspect
               c
            when '0'..'9' then
               n := c.code #- '0'.code
            when 'a'..'f' then
               n := c.code #- 'a'.code #+ 10
            when 'A'..'F' then
               n := c.code #- 'A'.code #+ 10
            end
            check
               n.in_range(0, 15)
            end
            Result := (Result #* 16) #+ n
            i := i + 1
         end
      end

   is_identifier_part (c: CHARACTER; string: STRING): BOOLEAN
      do
         inspect
            c
         when 'A' .. 'Z', 'a' .. 'z' then
            Result := True
         when '0' .. '9', '_' then
            Result := not string.is_empty
         else
            check
               not Result
            end
         end
      end

   identifier_filter: PREDICATE[TUPLE[CHARACTER, STRING]]
      once
         Result := agent is_identifier_part
      end

   identifier_image (buffer: MINI_PARSER_BUFFER; filter: PREDICATE[TUPLE[CHARACTER, STRING]]): STRING
      do
         if not buffer.end_reached and then filter.item([buffer.current_character, once ""]) then
            Result := once ""
            Result.clear_count
            from
               Result.extend(buffer.current_character)
               next_character(buffer)
            until
               buffer.end_reached or else not filter.item([buffer.current_character, Result])
            loop
               Result.extend(buffer.current_character)
               next_character(buffer)
            end
         end
      end

   parse_identifier (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         image := identifier_image(buffer, identifier_filter)
         if image = Void or else is_a_keyword(image) then
            restore(buffer, old_position)
         else
            if image.is_equal(once "U") and then not buffer.end_reached and then buffer.current_character = '"' then
               -- It's not an identifier name but the beginning of a Unicode string
               restore(buffer, old_position)
            else
               create Result.make(image.twin, last_blanks.twin, start_position)
            end
         end
      end

   is_a_keyword (id: STRING): BOOLEAN
      do
         inspect
            id
         when
            "and",
            "book",
            "bottom",
            "const",
            "do",
            "down",
            "else",
            "elseif",
            "end",
            "export",
            "for",
            "from",
            "function",
            "hidden",
            "if",
            "implies",
            "import",
            "in",
            "inspect",
            "instrument",
            "lyrics",
            "module",
            "music",
            "native",
            "not",
            "or",
            "partitur",
            "score",
            "set",
            "then",
            "top",
            "up",
            "when",
            "xor",
            "yield"
          then
            Result := True
         when
            "False",
            "Result",
            "True"
          then
            Result := True
         else
            check
               not Result
            end
         end
      end

   keyword_image (buffer: MINI_PARSER_BUFFER; keyword, not_successors: STRING): STRING
      local
         old_position, start_position: like position; i: INTEGER; c: CHARACTER
      do
         old_position := position
         start_position := position
         from
            Result := keyword
            i := keyword.lower
         until
            i > keyword.upper or else Result = Void
         loop
            if buffer.end_reached or else buffer.current_character /= keyword.item(i) then
               Result := Void
               restore(buffer, old_position)
            else
               next_character(buffer)
               i := i + 1
            end
         end
         if buffer.end_reached  then
            -- note that the end was reached with a completely correct parsing, just incomplete
            end_reached := True
         else
            -- be sure that the keyword is not just the prefix of another word
            c := buffer.current_character
            if not_successors = Void then
               if not c.is_separator and then keyword.first.is_letter_or_digit and then (c.is_letter_or_digit or else c = '_') then
                  Result := Void
                  restore(buffer, old_position)
               end
            elseif not_successors.has(c) then
               Result := Void
               restore(buffer, old_position)
            end
         end
      end

   parse_keyword (buffer: MINI_PARSER_BUFFER; keyword: STRING): UNTYPED_MIXUP_IMAGE
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         image := keyword_image(buffer, keyword, Void)
         if image /= Void then
            -- `image' may be shared here
            create Result.make(image, last_blanks.twin, start_position)
         else
            restore(buffer, old_position)
         end
      end

   parse_symbol (buffer: MINI_PARSER_BUFFER; keyword, not_successors: STRING): UNTYPED_MIXUP_IMAGE
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         image := keyword_image(buffer, keyword, not_successors)
         if image /= Void then
            -- `image' may be shared here
            create Result.make(image, last_blanks.twin, start_position)
         else
            restore(buffer, old_position)
         end
      end

   parse_boolean (buffer: MINI_PARSER_BUFFER): TYPED_MIXUP_IMAGE[BOOLEAN]
      local
         old_position, start_position: like position; image: STRING
         value: BOOLEAN
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         inspect
            buffer.current_character
         when 'T' then
            image := keyword_image(buffer, once "True", Void)
            value := True
         when 'F' then
            image := keyword_image(buffer, once "False", Void)
            value := False
         else
            check image = Void end
         end
         if image /= Void then
            -- `image' may be shared here
            create Result.make(image, value, last_blanks.twin, start_position)
         else
            restore(buffer, old_position)
         end
      end

   parse_syllable (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         inspect
            buffer.current_character
         when '"', '\', '>' then
            check Result = Void end
            restore(buffer, old_position)
         else
            from
               image := ""
            until
               buffer.end_reached or else buffer.current_character.is_separator
            loop
               image.extend(buffer.current_character)
               next_character(buffer)
            end
            if buffer.end_reached then
               end_reached := True
            end
            create Result.make(image, last_blanks.twin, start_position)
         end
      end

   is_note_head_part (c: CHARACTER; string: STRING): BOOLEAN
      do
         inspect
            string.count
         when 0 then
            inspect
               c
            when 'a' .. 'g', 'r', 'R', 's' then
               Result := True
            else
               check not Result end
            end
         when 1 then
            inspect
               c
            when 'e', 'i' then
               inspect
                  string.first
               when 'r', 'R', 's' then
               else
                  Result := True
               end
            else
               check not Result end
            end
         when 2 then
            inspect
               string.last
            when 'e', 'i' then
               Result := c = 's'
            else
               check not Result end
            end
         else
            check not Result end
         end
      end

   note_head_filter: PREDICATE[TUPLE[CHARACTER, STRING]]
      once
         Result := agent is_note_head_part
      end

   parse_note_head (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         image := identifier_image(buffer, note_head_filter)
         if image /= Void and then not buffer.end_reached and then is_identifier_part(buffer.current_character, once "") then
            image := Void
         end
         if image = Void then
            restore(buffer, old_position)
         else
            if buffer.end_reached then
               end_reached := True
            end
            create Result.make(image.twin, last_blanks.twin, start_position)
         end
      end

feature {}
   stack: FAST_ARRAY[MIXUP_NODE]
   left_assoc_stack: FAST_ARRAY[MIXUP_LEFT_ASSOCIATIVE_EXPRESSION]

   show_stack
      local
         i: INTEGER
      do
         log.trace.put_line(once "--8<-------- <start stack>")
         from
            i := stack.lower
         until
            i > stack.upper
         loop
            log.trace.put_line(&i | once ":%T" | stack.item(i).name)
            i := i + 1
         end
         log.trace.put_line(once "-------->8-- <end stack>")
      end

   stack_matches (node_content: TRAVERSABLE[FIXED_STRING]): BOOLEAN
      local
         i: INTEGER
      do
         Result := node_content /= Void and then stack.count >= node_content.count
         from
            i := 0
         until
            not Result or else i >= node_content.count
         loop
            Result := node_content.item(i + node_content.lower) = stack.item(stack.upper - node_content.count + 1 + i).name
            if not Result then
               breakpoint
            end
            i := i + 1
         end
      ensure
         used_only_in_assertions: Result
      end

   build_non_terminal (node_name: FIXED_STRING; node_content: TRAVERSABLE[FIXED_STRING])
      require
         stack_matches(node_content)
      local
         i: INTEGER; new_node: MIXUP_NON_TERMINAL_NODE; node: MIXUP_NODE
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building non-terminal node: %"" | node_name | once "%"")
         end
         new_node := factory.non_terminal(node_name, node_content)
         from
            i := node_content.upper
         until
            i < node_content.lower
         loop
            node := stack.last
            stack.remove_last
            new_node.set(i, node)
            debug ("parse/mixup/build")
               log.trace.put_line(once "   aggregating: " | node_content.item(i))
            end
            i := i - 1
         end
         stack.add_last(new_node)
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         node_content.count = old node_content.count
         stack.count = old stack.count - node_content.count + 1
         stack.last.name.is_equal(node_name)
      end

   build_terminal (node_name: FIXED_STRING; node_image: PARSER_IMAGE)
      local
         mixup_image: MIXUP_IMAGE
      do
         mixup_image ::= node_image
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building terminal node: %"" | node_name | once "%": " | mixup_image.image)
         end
         stack.add_last(factory.terminal(node_name, mixup_image))
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         stack.count = old stack.count + 1
         stack.last.name.is_equal(node_name)
      end

   build_empty_list (list_name: ABSTRACT_STRING)
      local
         list: MIXUP_LIST_NODE
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building new empty list %"" | list_name | once "%"")
         end
         list := factory.list(list_name.intern)
         stack.add_last(list)
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         stack.count = old stack.count + 1
         stack.last.name = list_name.intern
      end

   build_new_list (atom_name, list_name: ABSTRACT_STRING)
      require
         not stack.is_empty
         stack.last.name.is_equal(atom_name)
      local
         atom: MIXUP_NODE; list: MIXUP_LIST_NODE
      do
         atom := stack.last
         stack.remove_last
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building new list %"" | list_name | once "%" with one atom: atom should be %"" | atom_name | once "%"")
            log.trace.put_line(once "   Found atom: " | atom.name)
         end
         list := factory.list(list_name.intern)
         list.add(atom)
         stack.add_last(list)
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         stack.count = old stack.count
         stack.last.name = list_name.intern
      end

   build_continue_list (atom_name: ABSTRACT_STRING; forget: INTEGER; list_name: ABSTRACT_STRING)
      require
         stack.count >= forget + 2
         stack.item(stack.upper).name.is_equal(list_name)
         stack.item(stack.upper - 1 - forget).name.is_equal(atom_name)
      local
         atom: MIXUP_NODE; list: MIXUP_LIST_NODE; i: INTEGER; forgotten_nodes: FAST_ARRAY[MIXUP_NODE]
      do
         atom := stack.last
         stack.remove_last
         check
            atom.name = list_name.intern
         end
         list ::= atom
         if forget > 0 then
            create forgotten_nodes.make(forget)
            from
               i := forget - 1
            until
               i < 0
            loop
               forgotten_nodes.put(stack.last, i)
               stack.remove_last
               i := i - 1
            end
         end
         atom := stack.last
         stack.remove_last
         atom.set_forgotten(forgotten_nodes)
         check
            atom.name = atom_name.intern
         end
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building list %"" | list_name | once "%" (continuation): atom should be %"" | atom_name | once "%"")
            log.trace.put_line(once "   Found list: " | list.name)
            log.trace.put_line(once "   Found atom: " | atom.name)
         end
         list.add(atom)
         stack.add_last(list)
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         stack.count = old stack.count - 1 - forget
         stack.last = old stack.last
      end

feature {} -- expressions
   build_expression_remainder (operator_names: FAST_ARRAY[ABSTRACT_STRING]; expression_name: FIXED_STRING)
      local
         tail: MIXUP_LEFT_ASSOCIATIVE_EXPRESSION
         exp: MIXUP_NODE; operator_nodes: COLLECTION[MIXUP_NODE]
         i: INTEGER
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building left-associative expression " | expression_name | once " using operator " | &operator_names)
         end

         exp := ensure_expression(stack.last, expression_name)
         stack.remove_last
         debug ("parse/mixup/build")
            log.trace.put_line(once "  => setting aside: " | exp.name)
         end
         create {FAST_ARRAY[MIXUP_NODE]} operator_nodes.with_capacity(operator_names.count)
         from
            i := operator_names.lower
         until
            i > operator_names.upper
         loop
            operator_nodes.add_last(stack.last)
            stack.remove_last
            i := i + 1
         end
         tail.set(expression_name, operator_names, exp, operator_nodes)
         left_assoc_stack.add_last(tail)

         debug ("parse/mixup/build")
            show_stack
         end
      end

   ensure_expression (expression: MIXUP_NODE; expression_name: FIXED_STRING): MIXUP_NON_TERMINAL_NODE
      local
         expname: STRING
      do
         if expression.name.is_equal(expression_name) then
            Result ::= expression
         else
            expname := once "..-exp"
            expname.make_from_string(expression_name)
            expname.append(once "-exp")
            if expression.name.is_equal(expname) then
               Result ::= expression
            else
               left_assoc_names.clear_count
               left_assoc_names.add_last(expression.name)
               Result := factory.non_terminal(expression_name, left_assoc_names.twin)
               Result.set(0, expression)
            end
         end
      end

   build_expression (expression_name: FIXED_STRING)
      local
         tail: MIXUP_LEFT_ASSOCIATIVE_EXPRESSION
         left, right: MIXUP_NODE; nt: MIXUP_NON_TERMINAL_NODE
         i: INTEGER; name: STRING
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building simple expression " | expression_name)
         end

         name := once "..-exp"
         name.make_from_string(expression_name)
         name.append(once "-exp")

         from
            left := ensure_expression(stack.last, expression_name)
            stack.remove_last
         invariant
            not left_assoc_stack.is_empty implies left_assoc_stack.last.expression_name = expression_name
         until
            left_assoc_stack.is_empty
         loop
            debug ("parse/mixup/build")
               log.trace.put_line(once "  left: " | left.name)
            end

            tail := left_assoc_stack.last
            left_assoc_stack.remove_last

            right := ensure_expression(tail.right_node, expression_name)
            debug ("parse/mixup/build")
               log.trace.put_line(once "  op: " | tail.operator_names_out)
               log.trace.put_line(once "  right: " | right.name)
            end

            left_assoc_names.clear_count
            left_assoc_names.add_last(left.name)
            tail.append_operators_in(left_assoc_names)
            left_assoc_names.add_last(expression_name)

            nt := factory.non_terminal(name.intern, left_assoc_names.twin)
            nt.set(nt.lower, left)
            nt.set(nt.upper, right)
            debug ("parse/mixup/build")
               log.trace.put_line(once "  => nt: " | nt.name)
            end
            check
               tail.operator_nodes.lower = 0
            end
            from
               i := tail.operator_nodes.lower
            until
               i > tail.operator_nodes.upper
            loop
               nt.set(nt.lower + i + 1, tail.operator_nodes.item(i))
               i := i + 1
            end

            left := nt
         end

         stack.add_last(left)
         debug ("parse/mixup/build")
            show_stack
         end
      end

   build_expression_epsilon (expression_name: FIXED_STRING)
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building epsilon expression " | expression_name)
         end

         stack.put(ensure_expression(stack.last, expression_name), stack.upper)

         debug ("parse/mixup/build")
            show_stack
         end
      end

   build_expression_e6
      do
         debug ("parse/mixup/build")
            log.trace.put_line(once "Building epsilon expression e6")
         end

         -- nothing

         debug ("parse/mixup/build")
            show_stack
         end
      end

   build_unary_expression (expression_name, node_name: FIXED_STRING)
      local
         exp, nt: MIXUP_NON_TERMINAL_NODE
      do
         build_expression(expression_name)

         debug ("parse/mixup/build")
            log.trace.put_line(once "Building unary expression")
         end

         exp ::= stack.last
         stack.remove_last

         left_assoc_names.clear_count
         left_assoc_names.add_last(exp.name)

         nt := factory.non_terminal(node_name, left_assoc_names.twin)
         nt.set(nt.lower, exp)

         stack.add_last(nt)
         debug ("parse/mixup/build")
            show_stack
         end
      end

feature {} -- buffer moves
   next_character (buffer: MINI_PARSER_BUFFER)
      do
         position.next(buffer)
      end

   restore (buffer: MINI_PARSER_BUFFER; a_position: like position)
      do
         position := a_position
         buffer.set_current_index(position.index)
      end

   position: MIXUP_POSITION

feature {}
   with_factory (a_factory: like factory)
      do
         factory := a_factory
         create stack.make(0)
         create left_assoc_stack.make(0)
      ensure
         factory = a_factory
         stack.is_empty
         left_assoc_stack.is_empty
      end

   default_create
      do
         with_factory(create {MIXUP_DEFAULT_NODE_FACTORY}.make)
      end

   factory: MIXUP_NODE_FACTORY

   left_assoc_names: FAST_ARRAY[FIXED_STRING]
      once
         create Result.with_capacity(4)
      end

feature {ANY}
   memo_save (buffer: MINI_PARSER_BUFFER): INTEGER
      do
         check
            integrity: position.index = buffer.current_index
         end
         Result := buffer.current_index
         if memory.fast_has(Result) then
            check
               coherence: memory.at(Result) = position
            end
         else
            memory.add(position, Result)
         end
      end

   memo_restore (a_memo: like memo_save; buffer: MINI_PARSER_BUFFER)
      do
         restore(buffer, memory.at(a_memo))
      end

   memo_is_valid (a_memo: like memo_save; buffer: MINI_PARSER_BUFFER): BOOLEAN
      do
         Result := memory.fast_has(a_memo)
      end

   memory: AVL_DICTIONARY[MIXUP_POSITION, INTEGER]

invariant
   stack /= Void
   left_assoc_stack /= Void

end -- class MIXUP_GRAMMAR

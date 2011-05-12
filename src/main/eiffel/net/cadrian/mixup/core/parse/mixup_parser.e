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
class MIXUP_PARSER

inherit
   MIXUP_LIST_NODE_IMPL_VISITOR
   MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
   MIXUP_TERMINAL_NODE_IMPL_VISITOR

insert
   MIXUP_NODE_HANDLER
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   parse (a_piece: like current_piece; a_file: like current_file; a_context_factory: like context_factory): MIXUP_CONTEXT is
      require
         a_piece /= Void
         a_file /= Void
         a_context_factory /= Void
      local
         old_root: like root_context
         old_context_factory: like context_factory
         old_piece: like current_piece
         old_file: like current_file
      do
         old_root := root_context
         root_context := Void
         old_context_factory := context_factory
         context_factory := a_context_factory
         old_piece := current_piece
         current_piece := a_piece
         old_file := current_file
         current_file := a_file
         --a_piece.generate(log.trace)
         --a_piece.display(log.trace, 0, "")
         a_piece.accept(Current)
         Result := root_context
         root_context := old_root
         context_factory := old_context_factory
         current_file := old_file
         current_piece := old_piece

         Result.run_hook(seed_player, once "at_load")
      end

   current_piece: MIXUP_NODE
   current_file: FIXED_STRING
   context_factory: FUNCTION[TUPLE[MIXUP_SOURCE, FIXED_STRING], MIXUP_CONTEXT]

feature {MIXUP_LIST_NODE_IMPL}
   visit_mixup_list_node_impl (node: MIXUP_LIST_NODE_IMPL) is
      do
         inspect
            node.name
         when "Expression*" then
            build_expression_list(node)
         when "Voice+" then
            build_voices(node)
         when "Identifier" then
            build_identifier(node)
         when "Identifier+" then
            build_identifier_list(node)
         else
            debug
               log.trace.put_line("Generic list node: " + node.name)
            end
            node.accept_all(Current)
         end
      end

feature {MIXUP_NON_TERMINAL_NODE_IMPL}
   visit_mixup_non_terminal_node_impl (node: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_compound_music: like last_compound_music
         old_voices: like last_voices
      do
         inspect
            node.name
         when "File", "File_Content" then
            node.node_at(0).accept(Current)
         when "Set" then
            build_definition(node, False)
         when "Export" then
            build_definition(node, True)
         when "Import" then
            build_import(node)
         when "Module" then
            build_module(node)
         when "Score" then
            build_score(node)
         when "Book" then
            build_book(node)
         when "Partitur" then
            build_partitur(node)
         when "Partitur_Content" then
            build_partitur_content(node)
         when "Music" then
            last_compound_music := Void
            last_voices := Void
            node.node_at(1).accept(Current)
         when "Music_Value" then
            old_compound_music := last_compound_music
            old_voices := last_voices
            last_compound_music := Void
            last_voices := Void
            node.node_at(1).accept(Current)
            create {MIXUP_MUSIC_VALUE} last_expression.make(new_source(node), last_compound_music)
            last_compound_music := old_compound_music
            last_voices := old_voices
         when "Lyrics" then
            node.node_at(1).accept(Current)
         when "Instrument" then
            build_instrument(node)
         when "Staff" then
            build_staff(node)
         when "Next_Bar" then
            build_next_bar(node)
         when "Extern_Notes" then
            build_extern_music(node)
         when "Extern_Syllable" then
            build_extern_syllables(node)
         when "Position" then
            build_dynamics_position(node)
         when "Dynamic_Identifier" then
            build_dynamic_identifier(node)
         when "Dynamic_String" then
            build_dynamic_string(node)
         when "Dynamic_Hairpin_Crescendo" then
            build_dynamic_hairpin_crescendo(node)
         when "Dynamic_Hairpin_Decrescendo" then
            build_dynamic_hairpin_decrescendo(node)
         when "Dynamic_End" then
            build_dynamic_end(node)
         when "Chord_Or_Tie" then
            build_chord_or_tie(node)
         when "Chord" then
            build_chord(node)
         when "Note_Head" then
            build_note_head(node)
         when "Note_Length" then
            build_note_length(node)
         when "Dot" then
            last_note_length := last_note_length + last_note_length // 2
         when "DotDot" then
            last_note_length := last_note_length + last_note_length // 2 + last_note_length // 4
         when "Beam" then
            build_beam(node)
         when "Slur" then
            build_slur(node)
         when "Phrasing_Slur" then
            build_phrasing_slur(node)
         when "Xuplet_Spec" then
            read_xuplet_spec(node)
         when "Strophe" then
            build_strophe(node)
         when "Syllable" then
            build_syllable(node)
         when "Identifier_Part" then
            build_identifier_part(node)
         when "Identifier_Args" then
            build_identifier_args(node)
         when "Signature" then
            build_signature(node)
         when "Arg" then
            build_signature_arg(node)
         when "Value" then
            build_value(node)
         when "Function_Native" then
            build_function_native(node)
         when "Function_User" then
            build_function_user(node)
         when "If_Then_Else" then
            build_if_then_else(node)
         when "If", "ElseIf" then
            build_if(node)
         when "Else" then
            build_else(node)
         when "Loop" then
            build_loop(node)
         when "Expression_Or_Assignment" then
            build_expression_or_assignment(node)
         when "Yield" then
            build_yield(node)
         when "e1-exp" then
            build_e1_exp(node)
         when "e2-exp" then
            build_e2_exp(node)
         when "e3-exp" then
            build_e3_exp(node)
         when "e4-exp" then
            build_e4_exp(node)
         when "e5-exp" then
            build_e5_exp(node)
         when "e6-exp" then
            build_e6_exp(node)
         when "e7-exp" then
            build_e7_exp(node)
         when "e7" then
            build_e7(node)
         when "List" then
            build_list(node)
         when "Dictionary" then
            build_dictionary(node)
         when "Expression_Pair" then
            build_expression_pair(node)
         else
            debug
               log.trace.put_line("Generic non-terminal node: " + node.name)
            end
            node.accept_all(Current)
         end
      end

feature {MIXUP_TERMINAL_NODE_IMPL}
   visit_mixup_terminal_node_impl (node: MIXUP_TERMINAL_NODE_IMPL) is
      local
         string_image: TYPED_MIXUP_IMAGE[STRING]
         integer_image: TYPED_MIXUP_IMAGE[INTEGER_64]
         real_image: TYPED_MIXUP_IMAGE[REAL]
         boolean_image: TYPED_MIXUP_IMAGE[BOOLEAN]
      do
         inspect
            node.name
         when "KW identifier" then
            name := node.image.image.intern
         when "KW Result" then
            create {MIXUP_RESULT} last_expression.make(new_source(node))
         when "KW syllable" then
            last_string := node.image.image
         when "KW string" then
            string_image ::= node.image
            last_string := string_image.image
            create {MIXUP_STRING} last_expression.make(new_source(node), string_image.decoded, last_string)
         when "KW number" then
            if integer_image ?:= node.image then
               integer_image ::= node.image
               create {MIXUP_INTEGER} last_expression.make(new_source(node), integer_image.decoded)
            elseif real_image ?:= node.image then
               real_image ::= node.image
               create {MIXUP_REAL} last_expression.make(new_source(node), real_image.decoded)
            else
               fatal("invalid number")
            end
         when "KW boolean" then
            boolean_image ::= node.image
            create {MIXUP_BOOLEAN} last_expression.make(new_source(node), boolean_image.decoded)
         when "KW note head" then
            last_note_head.copy(node.image.image)
         else
            debug
               log.trace.put_line("Skipped terminal node: " + node.name)
            end
            -- skipped
         end
      end

feature {}
   root_context:            MIXUP_CONTEXT
   name:                    FIXED_STRING
   current_identifier:      MIXUP_IDENTIFIER
   last_identifier:         MIXUP_IDENTIFIER
   last_identifiers:        FAST_ARRAY[MIXUP_IDENTIFIER]
   last_expression:         MIXUP_EXPRESSION
   last_expressions:        FAST_ARRAY[MIXUP_EXPRESSION]
   last_dictionary:         MIXUP_DICTIONARY
   last_note_length:        INTEGER_64
   last_note_head:          STRING is ""
   note_heads:              FAST_ARRAY[TUPLE[MIXUP_SOURCE, FIXED_STRING]]
   last_compound_music:     MIXUP_COMPOUND_MUSIC
   current_context:         MIXUP_CONTEXT
   last_string:             STRING
   last_xuplet_numerator:   INTEGER_64
   last_xuplet_denominator: INTEGER_64
   last_xuplet_text:        FIXED_STRING
   last_voices:             MIXUP_VOICES
   staves:                  FAST_ARRAY[MIXUP_STAFF]

   build_identifier_list (identifiers: MIXUP_LIST_NODE_IMPL) is
      do
         check
            last_identifiers.is_empty
         end
         last_identifiers.with_capacity(identifiers.count)
         identifiers.accept_all(Current)
      end

   build_identifier (dot_identifier: MIXUP_LIST_NODE_IMPL) is
      local
         old_identifier: like current_identifier
      do
         old_identifier := current_identifier
         create current_identifier.make(new_source(dot_identifier))
         dot_identifier.accept_all(Current)
         last_expression := current_identifier
         last_identifier := current_identifier
         if last_identifiers /= Void then
            last_identifiers.add_last(last_identifier)
         end
         current_identifier := old_identifier
      end

   build_identifier_part (identifier_part: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         identifier_part.node_at(0).accept(Current)
         current_identifier.add_identifier_part(new_source(identifier_part), name)
         identifier_part.node_at(1).accept(Current)
      end

   build_identifier_args (identifier_args: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_expressions: like last_expressions
      do
         if not identifier_args.is_empty then
            old_expressions := last_expressions
            create last_expressions.make(0)
            identifier_args.node_at(1).accept(Current)
            current_identifier.set_args(last_expressions)
            last_expressions := old_expressions
         end
      end

   build_value (value: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_expression := Void
         value.accept_all(Current)
         check
            last_expression /= Void
         end
      end

   build_expression_list (expression_list: MIXUP_LIST_NODE_IMPL) is
      require
         last_expressions.is_empty
      local
         i: INTEGER
      do
         last_expressions.with_capacity((expression_list.count + 1) // 2)
         from
            i := expression_list.lower
         until
            i > expression_list.upper
         loop
            expression_list.item(i).accept(Current)
            last_expressions.add_last(last_expression)
            i := i + 1
         end
      end

   build_voices (a_voices: MIXUP_LIST_NODE_IMPL) is
      local
         i: INTEGER; old_compound_music: like last_compound_music
         voices: MIXUP_VOICES
      do
         old_compound_music := last_compound_music
         if old_compound_music = Void then
            create voices.make(new_source(a_voices.parent), absolute_reference)
         else
            create voices.make(new_source(a_voices.parent), old_compound_music.reference)
         end
         last_compound_music := voices
         last_voices := voices

         from
            i := a_voices.lower
         until
            i > a_voices.upper
         loop
            voices.next_voice(new_source(a_voices.item(i)))
            a_voices.item(i).accept(Current)
            i := i + 1
         end

         if old_compound_music /= Void then
            old_compound_music.add_music(voices)
            last_compound_music := old_compound_music
         end
      end

   build_staff (staff: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         staff.node_at(0).accept(Current)
         staves.add_last(create {MIXUP_STAFF}.make(new_source(staff), last_voices))
         last_voices := Void
         last_compound_music := Void
      end

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set(create {MIXUP_SOURCE_UNKNOWN}, "a", 4)
      end

   read_xuplet_spec (spec: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         int: MIXUP_INTEGER; str: MIXUP_STRING; string: STRING
      do
         if spec.is_empty then
            last_xuplet_numerator := 0
            last_xuplet_denominator := 0
            last_xuplet_text := Void
         else
            spec.node_at(0).accept(Current)
            int ::= last_expression
            last_xuplet_numerator := int.value
            spec.node_at(2).accept(Current)
            int ::= last_expression
            last_xuplet_denominator := int.value

            if spec.count = 3 then
               string := once ""
               string.clear_count
               last_xuplet_numerator.append_in(string)
               last_xuplet_text := string.intern
            else
               spec.node_at(3).accept(Current)
               str ::= last_expression
               last_xuplet_text := str.value
            end
         end
      end

feature {} -- Functions
   last_function:   MIXUP_FUNCTION
   last_statements: FAST_ARRAY[MIXUP_STATEMENT]
   last_signature:  FAST_ARRAY[FIXED_STRING]

   build_signature (signature: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_signature.make(0)
         if not signature.is_empty then
            signature.node_at(1).accept(Current)
         end
      end

   build_signature_arg (arg: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         arg.node_at(0).accept(Current)
         last_signature.add_last(name)
      end

   build_function_native (function_native: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         string: MIXUP_STRING; str: STRING
      do
         function_native.node_at(1).accept(Current)
         string ::= last_expression
         str := once ""
         str.clear_count
         str.append(string.value)
         source := new_source(function_native)
         create {MIXUP_NATIVE_FUNCTION} last_function.make(source, string.value, current_context, native_provider.item(source, str))
         last_expression := last_function
      end

   build_function_user (function_user: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         check
            last_statements = Void
         end
         create last_statements.with_capacity(4)
         function_user.node_at(1).accept(Current)
         create {MIXUP_USER_FUNCTION} last_function.make(new_source(function_user), current_context, last_statements, last_signature)
         last_expression := last_function
         last_statements := Void
      end

   current_if_then_else: MIXUP_IF_THEN_ELSE

   build_if_then_else (a_if_then_else: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_if_then_else: like current_if_then_else
      do
         old_if_then_else := current_if_then_else

         create current_if_then_else.make(new_source(a_if_then_else))
         a_if_then_else.node_at(0).accept(Current)
         a_if_then_else.node_at(1).accept(Current)
         a_if_then_else.node_at(2).accept(Current)
         last_statements.add_last(current_if_then_else)

         current_if_then_else := old_if_then_else
      end

   build_if (a_if: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         old_statements: like last_statements
      do
         a_if.node_at(1).accept(Current)
         exp := last_expression
         old_statements := last_statements
         create last_statements.with_capacity(4)
         a_if.node_at(3).accept(Current)
         current_if_then_else.add_condition(create {MIXUP_IF}.make(new_source(a_if), exp, last_statements))
         last_statements := old_statements
      end

   build_else (a_else: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_statements: like last_statements
      do
         if not a_else.is_empty then
            old_statements := last_statements
            create last_statements.with_capacity(4)
            a_else.node_at(1).accept(Current)
            current_if_then_else.set_otherwise(create {MIXUP_ELSE}.make(new_source(a_else), last_statements))
            last_statements := old_statements
         end
      end

   build_loop (a_loop: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         loop_identifier: like name
         exp: like last_expression
         old_statements: like last_statements
      do
         a_loop.node_at(1).accept(Current)
         loop_identifier := name
         a_loop.node_at(3).accept(Current)
         exp := last_expression

         old_statements := last_statements
         create last_statements.with_capacity(4)
         a_loop.node_at(5).accept(Current)
         old_statements.add_last(create {MIXUP_LOOP}.make(new_source(a_loop), loop_identifier, exp, last_statements))
         last_statements := old_statements
      end

   build_expression_or_assignment (a_expression_or_assignment: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
      do
         if a_expression_or_assignment.count = 1 then
            a_expression_or_assignment.node_at(0).accept(Current)
            last_statements.add_last(create {MIXUP_EXPRESSION_AS_STATEMENT}.make(new_source(a_expression_or_assignment), last_expression))
         else
            a_expression_or_assignment.node_at(2).accept(Current)
            exp := last_expression
            last_identifier := Void
            a_expression_or_assignment.node_at(0).accept(Current)
            if last_identifier = Void then
               if not ({MIXUP_RESULT} ?:= last_expression) then
                  fatal("assignment: expected either Result or an identifier")
               end
               last_statements.add_last(create {MIXUP_RESULT_ASSIGNMENT}.make(new_source(a_expression_or_assignment), exp))
            else
               if last_expression /= last_identifier then
                  fatal("assignment: expected either Result or an identifier")
               end
               last_statements.add_last(create {MIXUP_ASSIGNMENT}.make(new_source(a_expression_or_assignment), last_identifier, exp))
            end
         end
      end

   build_yield (a_yield: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         a_yield.node_at(1).accept(Current)
         last_statements.add_last(create {MIXUP_YIELD}.make(new_source(a_yield), last_expression))
      end

   build_definition (definition: MIXUP_NON_TERMINAL_NODE_IMPL; is_public: BOOLEAN) is
      local
         definition_name: FIXED_STRING
         def_value: MIXUP_VALUE
         is_const: BOOLEAN
      do
         if definition.count = 5 then -- const
            check is_public end
            definition.node_at(2).accept(Current)
            definition_name := last_identifier.as_name.intern
            definition.node_at(4).accept(Current)
            def_value ::= last_expression
            is_const := True
         else
            definition.node_at(1).accept(Current)
            definition_name := last_identifier.as_name.intern
            definition.node_at(3).accept(Current)
            def_value ::= last_expression
         end
         current_context.setup(definition_name, def_value, is_const, is_public, False)
      end

   build_import (import: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         ctx: MIXUP_CONTEXT
         ctx_name: FIXED_STRING
         source_: like source
      do
         import.node_at(1).accept(Current)
         ctx_name := last_identifier.as_name.intern
         source_ := new_source(import)
         ctx := context_factory.item([source_, ctx_name])
         if import.count = 2 then
            create {MIXUP_IMPORT} ctx.make(source_, ctx_name, current_context, ctx)
         else
            check last_identifiers = Void end
            create last_identifiers.make(0)
            import.node_at(3).accept(Current)
            create {MIXUP_FROM_IMPORT} ctx.make(source_, ctx_name, current_context, ctx, last_identifiers)
            last_identifiers := Void
         end
      end

   build_e1_exp (a_e1: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e1.node_at(0).accept(Current)
            i := 1
         until
            i > a_e1.upper
         loop
            exp := last_expression
            a_e1.node_at(i + 1).accept(Current)
            create {MIXUP_IMPLIES} last_expression.make(new_source(a_e1), exp, last_expression)
            i := i + 2
         end
      end

   build_e2_exp (a_e2: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e2.node_at(0).accept(Current)
            i := 1
         until
            i > a_e2.upper
         loop
            exp := last_expression
            a_e2.node_at(i + 1).accept(Current)
            inspect
               a_e2.node_at(i).name
            when "KW or" then
               create {MIXUP_OR} last_expression.make(new_source(a_e2), exp, last_expression)
            when "KW xor" then
               create {MIXUP_XOR} last_expression.make(new_source(a_e2), exp, last_expression)
            end
            i := i + 2
         end
      end

   build_e3_exp (a_e3: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e3.node_at(0).accept(Current)
            i := 1
         until
            i > a_e3.upper
         loop
            exp := last_expression
            a_e3.node_at(i + 1).accept(Current)
            create {MIXUP_AND} last_expression.make(new_source(a_e3), exp, last_expression)
            i := i + 2
         end
      end

   build_e4_exp (a_e4: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e4.node_at(0).accept(Current)
            i := 1
         until
            i > a_e4.upper
         loop
            exp := last_expression
            a_e4.node_at(i + 1).accept(Current)
            inspect
               a_e4.node_at(i).name
            when "KW =" then
               create {MIXUP_EQ} last_expression.make(new_source(a_e4), exp, last_expression)
            when "KW !=" then
               create {MIXUP_NE} last_expression.make(new_source(a_e4), exp, last_expression)
            when "KW <=" then
               create {MIXUP_LE} last_expression.make(new_source(a_e4), exp, last_expression)
            when "KW <" then
               create {MIXUP_LT} last_expression.make(new_source(a_e4), exp, last_expression)
            when "KW >=" then
               create {MIXUP_GE} last_expression.make(new_source(a_e4), exp, last_expression)
            when "KW >" then
               create {MIXUP_GT} last_expression.make(new_source(a_e4), exp, last_expression)
            end
            i := i + 2
         end
      end

   build_e5_exp (a_e5: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e5.node_at(0).accept(Current)
            i := 1
         until
            i > a_e5.upper
         loop
            exp := last_expression
            a_e5.node_at(i + 1).accept(Current)
            inspect
               a_e5.node_at(i).name
            when "KW +" then
               create {MIXUP_ADD} last_expression.make(new_source(a_e5), exp, last_expression)
            when "KW -" then
               create {MIXUP_SUBTRACT} last_expression.make(new_source(a_e5), exp, last_expression)
            end
            i := i + 2
         end
      end

   build_e6_exp (a_e6: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e6.node_at(0).accept(Current)
            i := 1
         until
            i > a_e6.upper
         loop
            exp := last_expression
            a_e6.node_at(i + 1).accept(Current)
            inspect
               a_e6.node_at(i).name
            when "KW *" then
               create {MIXUP_MULTIPLY} last_expression.make(new_source(a_e6), exp, last_expression)
            when "KW /" then
               create {MIXUP_DIVIDE} last_expression.make(new_source(a_e6), exp, last_expression)
            when "KW //" then
               create {MIXUP_INTEGER_DIVIDE} last_expression.make(new_source(a_e6), exp, last_expression)
            when "KW \\" then
               create {MIXUP_INTEGER_MODULO} last_expression.make(new_source(a_e6), exp, last_expression)
            end
            i := i + 2
         end
      end

   build_e7_exp (a_e7: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         exp: like last_expression
         i: INTEGER
      do
         from
            a_e7.node_at(a_e7.upper).accept(Current)
            i := a_e7.upper - 2
         until
            i < a_e7.lower
         loop
            exp := last_expression
            a_e7.node_at(i).accept(Current)
            create {MIXUP_POWER} last_expression.make(new_source(a_e7), last_expression, exp)
            i := i - 2
         end
      end

   build_e7 (a_e7: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         -- TODO: unary operators
         a_e7.accept_all(Current)
      end

   build_list (a_list: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_expressions: like last_expressions
      do
         old_expressions := last_expressions
         create last_expressions.make(0)
         a_list.node_at(1).accept(Current)
         create {MIXUP_LIST} last_expression.make(new_source(a_list), last_expressions)
         last_expressions := old_expressions
      end

   build_dictionary (a_dictionary: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_dictionary: like last_dictionary
      do
         old_dictionary := last_dictionary
         create last_dictionary.make(new_source(a_dictionary))
         a_dictionary.node_at(1).accept(Current)
         last_expression := last_dictionary
         last_dictionary := old_dictionary
      end

   build_expression_pair (a_expression_pair: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         key: like last_expression
      do
         a_expression_pair.node_at(0).accept(Current)
         key := last_expression
         a_expression_pair.node_at(2).accept(Current)
         last_dictionary.add(last_expression, key)
      end

feature {}
   build_context (context_node: MIXUP_NON_TERMINAL_NODE_IMPL; factory: FUNCTION[TUPLE[MIXUP_SOURCE, MIXUP_CONTEXT], MIXUP_CONTEXT]) is
      local
         old_context: like current_context
      do
         old_context := current_context
         context_node.node_at(1).accept(Current)
         current_context := factory.item([new_source(context_node), old_context])
         if root_context = Void then
            root_context := current_context
         end
         context_node.node_at(2).accept(Current)
         current_context := old_context
      end

   build_module (module: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_context(module, agent (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT): MIXUP_CONTEXT is do create {MIXUP_MODULE} Result.make(a_source, name, context) end)
      end

   build_score (score: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_context(score, agent (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT): MIXUP_CONTEXT is do create {MIXUP_SCORE} Result.make(a_source, name, context) end)
      end

   build_book (book: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_context(book, agent (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT): MIXUP_CONTEXT is do create {MIXUP_BOOK} Result.make(a_source, name, context) end)
      end

   build_partitur (partitur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_context(partitur, agent (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT): MIXUP_CONTEXT is do create {MIXUP_PARTITUR} Result.make(a_source, name, context) end)
      end

   build_partitur_content (partitur_content: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         partitur_content.accept_all(Current)
      end

   build_instrument (instrument: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         create staves.make(0)
         instrument.node_at(1).accept(Current)
         create current_instrument.make(new_source(instrument), name, old_context)
         current_context := current_instrument
         if root_context = Void then
            root_context := current_context
         end
         check
            current_instrument /= Void
            last_compound_music = Void
         end
         instrument.node_at(2).accept(Current)
         instrument.node_at(3).accept(Current)
         current_instrument.set_staves(staves)
         last_compound_music := Void
         current_context := old_context
         current_instrument := Void
      end

   build_next_bar (next_bar: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.add_bar(new_source(next_bar), Void)
      end

   build_extern_music (music: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         music.node_at(1).accept(Current)
         last_compound_music.add_music(create {MIXUP_MUSIC_IDENTIFIER}.make(new_source(music), last_identifier))
      end

   build_group (group: MIXUP_NON_TERMINAL_NODE_IMPL; grouped_music: MIXUP_GROUPED_MUSIC) is
      local
         old_compound_music: like last_compound_music
         xnumerator, xdenominator: INTEGER_64; xtext: FIXED_STRING
      do
         old_compound_music := last_compound_music

         group.node_at(1).accept(Current)
         xnumerator := last_xuplet_numerator
         xdenominator := last_xuplet_denominator
         xtext := last_xuplet_text

         last_compound_music := grouped_music
         group.node_at(2).accept(Current)
         old_compound_music.add_music(grouped_music)

         if xtext /= Void then
            grouped_music.set_xuplet(xnumerator, xdenominator, xtext)
         end
         last_compound_music := old_compound_music
      end

   build_beam (beam: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_group(beam, create {MIXUP_GROUPED_MUSIC}.as_beam(new_source(beam), last_compound_music.reference))
      end

   build_slur (slur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_group(slur, create {MIXUP_GROUPED_MUSIC}.as_slur(new_source(slur), last_compound_music.reference))
      end

   build_phrasing_slur (phrasing_slur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         build_group(phrasing_slur, create {MIXUP_GROUPED_MUSIC}.as_phrasing_slur(new_source(phrasing_slur), last_compound_music.reference))
      end

   last_chord_tie: BOOLEAN
   build_chord_or_tie (chord_or_tie: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         if chord_or_tie.count = 1 then
            last_chord_tie := False
         else
            last_chord_tie := True
         end
         chord_or_tie.node_at(0).accept(Current)
      end

   build_chord (chord: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create note_heads.make(0)
         if chord.count = 2 then
            chord.node_at(0).accept(Current)
            chord.node_at(1).accept(Current)
         else
            chord.node_at(1).accept(Current)
            chord.node_at(3).accept(Current)
         end
         last_compound_music.add_chord(new_source(chord), note_heads, last_note_length, last_chord_tie)
      end

   build_note_head (note_head: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         token: MIXUP_TERMINAL_NODE_IMPL
      do
         note_head.node_at(0).accept(Current)
         if note_head.count > 1 then
            inspect
               last_note_head.first
            when 'r', 'R' then
               error("unexpected octave change for rest")
            else
               token ::= note_head.node_at(1)
               last_note_head.append(token.image.image)
               if note_head.count = 3 then
                  token ::= note_head.node_at(2)
                  last_note_head.append(token.image.image)
               end
            end
         end
         note_heads.add_last([new_source(note_head), last_note_head.intern])
      end

   build_note_length (note_length: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         number: MIXUP_INTEGER
      do
         if note_length.count = 0 then
            -- OK, keep previous
         else
            note_length.node_at(0).accept(Current)
            if number ?:= last_expression then
               number ::= last_expression
               last_note_length := number.value
               inspect
                  last_note_length
               when 1, 2, 4, 8, 16, 32, 64 then
                  last_note_length := {INTEGER_64 256} // last_note_length -- make it divisible by 4 (because of dots), and restore a correct order in lengths
                  if note_length.count > 1 then
                     note_length.node_at(1).accept(Current)
                  end
               else
                  fatal("invalid note length")
               end
            else
               fatal("invalid note length")
            end
         end
      end

feature {} -- Dynamics
   last_position: FIXED_STRING
   last_dynamics: MIXUP_DYNAMICS

   build_dynamics_position (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         position: MIXUP_TERMINAL_NODE_IMPL
      do
         if dynamic.is_empty then
            last_position := Void
         else
            position ::= dynamic.node_at(0)
            last_position := position.image.image.intern
         end
      end

   build_dynamic_identifier (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         dynamic.node_at(0).accept(Current)
         create last_dynamics.make(new_source(dynamic), name.intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_string (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         dynamic.node_at(0).accept(Current)
         create last_dynamics.make(new_source(dynamic), last_string.intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_hairpin_crescendo (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make(new_source(dynamic), (once "<").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_hairpin_decrescendo (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make(new_source(dynamic), (once ">").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_end (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make(new_source(dynamic), (once "end").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

feature {}
   current_instrument: MIXUP_INSTRUMENT

   play_notes (notes: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         notes.accept_all(Current)
      end

   build_strophe (strophe: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         current_instrument.next_strophe
         strophe.node_at(1).accept(Current)
      end

   build_syllable (syllable: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         syllable.accept_all(Current)
         current_instrument.add_syllable(last_string)
      end

   build_extern_syllables (syllables: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         syllables.node_at(1).accept(Current)
         current_instrument.add_extern_syllables(last_identifier)
      end

feature {}
   make (a_seed_player: like seed_player; a_native_provider: like native_provider) is
      require
         a_seed_player /= Void
         a_native_provider /= Void
      do
         seed_player := a_seed_player
         native_provider := a_native_provider
      ensure
         seed_player = a_seed_player
         native_provider = a_native_provider
      end

   new_source (node: MIXUP_NODE): MIXUP_SOURCE_IMPL is
      local
         line, column: INTEGER
      do
         line := node.source_line
         column := node.source_column
         if line = 0 and then column = 0 then
            sedb_breakpoint
         end
         create Result.make(current_piece, current_file, line, column)
      end

   native_provider: MIXUP_NATIVE_PROVIDER
   seed_player: MIXUP_PLAYER

invariant
   native_provider /= Void
   seed_player /= Void

end -- class MIXUP_PARSER

class MIXUP_GRAMMAR

insert
   MIXUP_NODE_HANDLER
      redefine
         default_create
      end
   PLATFORM
      redefine
         default_create
      end

create {ANY}
   with_factory, default_create

feature {ANY}
   end_reached: BOOLEAN

feature {}
   list_of (element_name: STRING; allow_empty: BOOLEAN): PARSE_ATOM is
      local
         list_name: STRING
      do
         if allow_empty then
            list_name := element_name + once "*"
            Result := {PARSE_NON_TERMINAL << epsilon, agent build_empty_list(list_name);
                                             {FAST_ARRAY[STRING] << element_name, list_name >> }, agent build_continue_list(element_name, 0, list_name) >> }
         else
            list_name := element_name + once "+"
            Result := {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << element_name >> }, agent build_new_list(element_name, list_name);
                                             {FAST_ARRAY[STRING] << element_name, list_name >> }, agent build_continue_list(element_name, 0, list_name) >> }
         end
      end

   the_table: PARSE_TABLE is
      once
         Result := {PARSE_TABLE << "File", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "File_Content", "KW end", "KW end of file" >> }, Void;
                                                                  >> };
                                   "File_Content", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Score" >> }, Void;
                                                                          {FAST_ARRAY[STRING] << "Book" >> }, Void;
                                                                          {FAST_ARRAY[STRING] << "Partitur" >> }, Void;
                                                                          {FAST_ARRAY[STRING] << "Instrument" >> }, Void;
                                                                          {FAST_ARRAY[STRING] << "Module" >> }, Void;
                                                                          >> };

                                   "Module", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW module", "KW identifier", "Definition*", "Score_Content" >> }, Void;
                                                                    >> };

                                   "Score", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW score", "KW identifier", "Score_Content" >> }, Void;
                                                                   >> };
                                   "Score_Content", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Definition*", "Book+" >> }, Void;
                                                                           {FAST_ARRAY[STRING] << "Book_Content" >> }, Void;
                                                                           >> };

                                   "Definition*", list_of("Definition", True);
                                   "Definition", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Export" >> }, Void;
                                                                        {FAST_ARRAY[STRING] << "Import" >> }, Void;
                                                                        {FAST_ARRAY[STRING] << "Set" >> }, Void;
                                                                        >> };

                                   "Export", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW export", "Identifier", "KW =", "Value" >> }, Void;
                                                                    {FAST_ARRAY[STRING] << "KW export", "KW const", "Identifier", "KW =", "Value" >> }, Void;
                                                                    >> };
                                   "Set", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW set", "Identifier", "KW =", "Value" >> }, Void;
                                                                 >> };
                                   "Import", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW from", "Identifier", "KW import", "Symbol+" >> }, Void;
                                                                    {FAST_ARRAY[STRING] << "KW from", "Identifier", "KW import", "KW *" >> }, Void;
                                                                    {FAST_ARRAY[STRING] << "KW import", "Identifier" >> }, Void;
                                                                    >> };

                                   "Symbol+", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW identifier" >> }, agent build_new_list("KW identifier", "Identifier");
                                                                     {FAST_ARRAY[STRING] << "KW identifier", "KW ,", "Symbol+" >> }, agent build_continue_list("KW identifier", 1, "Identifier")
                                                                     >> };

                                   "Book+", list_of("Book", False);
                                   "Book", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW book", "KW identifier", "Book_Content" >> }, Void;
                                                                  >> };
                                   "Book_Content", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Definition*", "Partitur+" >> }, Void;
                                                                          {FAST_ARRAY[STRING] << "Partitur_Content" >> }, Void;
                                                                          >> };

                                   "Partitur+", list_of("Partitur", False);
                                   "Partitur", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW partitur", "KW identifier", "Partitur_Content" >> }, Void;
                                                                      >> };
                                   "Partitur_Content", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Definition*", "Instrument+" >> }, Void;
                                                                              >> };

                                   "Instrument+", list_of("Instrument", False);
                                   "Instrument", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW instrument", "KW identifier", "Definition*", "Some_Music", "KW end" >> }, Void;
                                                                        >> };

                                   "Some_Music", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                        {FAST_ARRAY[STRING] << "Identifier", "Some_Lyrics" >> }, Void;
                                                                        {FAST_ARRAY[STRING] << "Music", "Some_Lyrics" >> }, Void;
                                                                        >> };

                                   "Some_Lyrics", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                         {FAST_ARRAY[STRING] << "Identifier" >> }, Void;
                                                                         {FAST_ARRAY[STRING] << "Lyrics" >> }, Void;
                                                                         >> };

                                   "Value", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "KW number" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "KW boolean" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Identifier" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Music" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Lyrics" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Function" >> }, Void;
                                                                   >> };

                                   "Identifier", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Identifier_Part" >> }, agent build_new_list("Identifier_Part", "Identifier");
                                                                        {FAST_ARRAY[STRING] << "Identifier_Part", "KW .", "Identifier" >> }, agent build_continue_list("Identifier_Part", 1, "Identifier")
                                                                        >> };
                                   "Identifier_Part", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW identifier", "Identifier_Args" >> }, Void;
                                                                             >> };
                                   "Identifier_Args", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                             {FAST_ARRAY[STRING] << "KW (", "Value*", "KW )" >> }, Void;
                                                                             >> };
                                   "Value*", {PARSE_NON_TERMINAL << epsilon, agent build_empty_list("Value*");
                                                                    {FAST_ARRAY[STRING] << "Value" >> }, agent build_new_list("Value", "Value*");
                                                                    {FAST_ARRAY[STRING] << "Value", "KW ,", "Value*" >> }, agent build_continue_list("Value", 1, "Value*")
                                                                    >> };

                                   "Lyrics", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW lyrics", "Strophe*" >> }, Void;
                                                                    >> };
                                   "Strophe*", list_of("Strophe", True);
                                   "Strophe", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW <<", "Word*", "KW >>" >> }, Void;
                                                                     >> };
                                   "Word*", list_of("Word", True);
                                   "Word", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Syllable+" >> }, Void;
                                                                  >> };
                                   "Syllable+", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Syllable" >> }, agent build_new_list("Syllable", "Syllable+");
                                                                       {FAST_ARRAY[STRING] << "Syllable", "KW -", "Syllable+" >> }, agent build_continue_list("Syllable", 1, "Syllable+")
                                                                       >> };
                                   "Syllable", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW syllable" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW \", "Identifier" >> }, Void;
                                                                      >> };

                                   "Music", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW music", "Notes*" >> }, Void;
                                                                   >> };

                                   "Notes*", list_of("Notes", True);
                                   "Notes", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW |" >> }, Void; -- check bar
                                                                   {FAST_ARRAY[STRING] << "KW ^" >> }, Void; -- next staff (going up; each voice starts at the lowest staff of the instrument)
                                                                   {FAST_ARRAY[STRING] << "KW ." >> }, Void; -- previous staff (going back down)
                                                                   {FAST_ARRAY[STRING] << "KW \", "Identifier" >> }, Void; -- music insertion
                                                                   {FAST_ARRAY[STRING] << "Dynamics", "Voice" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Dynamics", "Chord" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Dynamics", "Beam" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Dynamics", "Slur" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "Dynamics", "Tie" >> }, Void;
                                                                   >> };

                                   "Chord", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW <", "KW note head+", "KW >", "Note_Length" >> }, Void;
                                                                   {FAST_ARRAY[STRING] << "KW note head+", "Note_Length" >> }, Void;
                                                                   >> };

                                   "Note_Length", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                         {FAST_ARRAY[STRING] << "KW number" >> }, Void;
                                                                         {FAST_ARRAY[STRING] << "KW number", "KW ." >> }, Void;
                                                                         {FAST_ARRAY[STRING] << "KW number", "KW .." >> }, Void;
                                                                         >> };

                                   "Dynamics", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                      {FAST_ARRAY[STRING] << "KW :", "Position", "Dynamic+", "KW :" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW :", "Position", "Dynamic+", "KW ...", "KW :" >> }, Void; -- dashed line along the whole dynamic section (not with hairpins!)
                                                                      >> };
                                   "Dynamic+", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "Dynamic" >> }, agent build_new_list("Dynamic", "Dynamic+");
                                                                      {FAST_ARRAY[STRING] << "Dynamic", "KW ,", "Dynamic+" >> }, agent build_continue_list("Dynamic", 1, "Dynamic+")
                                                                      >> };
                                   "Dynamic",  {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW identifier" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW string" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW <" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW >" >> }, Void;
                                                                      {FAST_ARRAY[STRING] << "KW end" >> }, Void; -- en of dynamic (stop hairpin, etc.)
                                                                      >> };
                                   "Position", {PARSE_NON_TERMINAL << epsilon, Void;
                                                                      {FAST_ARRAY[STRING] << "KW up", "KW :" >> }, Void; -- up current staff
                                                                      {FAST_ARRAY[STRING] << "KW down", "KW :" >> }, Void; -- down current staff
                                                                      {FAST_ARRAY[STRING] << "KW top", "KW :" >> }, Void; -- up current instrument
                                                                      {FAST_ARRAY[STRING] << "KW bottom", "KW :" >> }, Void; -- down current instrument
                                                                      {FAST_ARRAY[STRING] << "KW hidden", "KW :" >> }, Void; -- don't display, for midi control only
                                                                      >> };

                                   "Voice", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW <<", "Notes*", "KW >>" >> }, Void;
                                                                   >> };
                                   "Beam", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW [", "Notes*", "KW ]" >> }, Void;
                                                                  >> };
                                   "Slur", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW {", "Notes*", "KW }" >> }, Void;
                                                                  >> };
                                   "Tie", {PARSE_NON_TERMINAL << {FAST_ARRAY[STRING] << "KW (", "Notes*", "KW )" >> }, Void;
                                                                 >> };

                                   "Function", {PARSE_NON_TERMINAL << epsilon, Void -- TODO: for output implementation
                                                                      >> };

                                   "KW note head+", list_of("KW note head", False);

                                   "KW ^",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "^" , ""),  Void);
                                   "KW <<",          create {PARSE_TERMINAL}.make(agent parse_symbol(?, "<<", ""),  Void);
                                   "KW <",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "<" , "<"), Void);
                                   "KW =",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "=" , ""),  Void);
                                   "KW >>",          create {PARSE_TERMINAL}.make(agent parse_symbol(?, ">>", ""),  Void);
                                   "KW >",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, ">" , ">"), Void);
                                   "KW |",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "|" , ""),  Void);
                                   "KW -",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "-" , ""),  Void);
                                   "KW ,",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "," , ""),  Void);
                                   "KW :",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, ":" , ""),  Void);
                                   "KW .",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "." , "."),  Void);
                                   "KW ..",          create {PARSE_TERMINAL}.make(agent parse_symbol(?, ".." , "."),  Void);
                                   "KW ...",         create {PARSE_TERMINAL}.make(agent parse_symbol(?, "..." , ""),  Void);
                                   "KW (",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "(" , ""),  Void);
                                   "KW )",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, ")" , ""),  Void);
                                   "KW [",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "[" , ""),  Void);
                                   "KW ]",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "]" , ""),  Void);
                                   "KW {",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "{" , ""),  Void);
                                   "KW }",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "}" , ""),  Void);
                                   "KW *",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "*" , ""),  Void);
                                   "KW \",           create {PARSE_TERMINAL}.make(agent parse_symbol(?, "\" , ""),  Void);

                                   "KW book",        create {PARSE_TERMINAL}.make(agent parse_keyword(?, "book"), Void);
                                   "KW bottom",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "bottom"), Void);
                                   "KW const",       create {PARSE_TERMINAL}.make(agent parse_keyword(?, "const"), Void);
                                   "KW down",        create {PARSE_TERMINAL}.make(agent parse_keyword(?, "down"), Void);
                                   "KW end",         create {PARSE_TERMINAL}.make(agent parse_keyword(?, "end"), Void);
                                   "KW export",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "export"), Void);
                                   "KW from",        create {PARSE_TERMINAL}.make(agent parse_keyword(?, "from"), Void);
                                   "KW hidden",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "hidden"), Void);
                                   "KW import",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "import"), Void);
                                   "KW instrument",  create {PARSE_TERMINAL}.make(agent parse_keyword(?, "instrument"), Void);
                                   "KW lyrics",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "lyrics"), Void);
                                   "KW module",      create {PARSE_TERMINAL}.make(agent parse_keyword(?, "module"), Void);
                                   "KW music",       create {PARSE_TERMINAL}.make(agent parse_keyword(?, "music"), Void);
                                   "KW partitur",    create {PARSE_TERMINAL}.make(agent parse_keyword(?, "partitur"), Void);
                                   "KW score",       create {PARSE_TERMINAL}.make(agent parse_keyword(?, "score"), Void);
                                   "KW set",         create {PARSE_TERMINAL}.make(agent parse_keyword(?, "set"), Void);
                                   "KW top",         create {PARSE_TERMINAL}.make(agent parse_keyword(?, "top"), Void);
                                   "KW up",          create {PARSE_TERMINAL}.make(agent parse_keyword(?, "up"), Void);

                                   "KW boolean",     create {PARSE_TERMINAL}.make(agent parse_boolean, Void);
                                   "KW identifier",  create {PARSE_TERMINAL}.make(agent parse_identifier, Void);
                                   "KW note head",   create {PARSE_TERMINAL}.make(agent parse_note_head, Void);
                                   "KW number",      create {PARSE_TERMINAL}.make(agent parse_number, Void);
                                   "KW string",      create {PARSE_TERMINAL}.make(agent parse_string, Void);
                                   "KW syllable",    create {PARSE_TERMINAL}.make(agent parse_syllable, Void);

                                   "KW end of file", create {PARSE_TERMINAL}.make(agent parse_end, Void) >> }
      end

   table_memory: PARSE_TABLE

feature {ANY}
   table: PARSE_TABLE is
      do
         Result := table_memory
         if Result = Void then
            Result := the_table
            Result.set_default_tree_builders(agent build_non_terminal, agent build_terminal)
            table_memory := Result
         end
      end

   display (output: OUTPUT_STREAM) is
      do
         if not stack.is_empty then
            stack.first.display(output, 0, Void)
         end
      end

   generate (o: OUTPUT_STREAM) is
      do
         if not stack.is_empty then
            stack.first.generate(o)
         end
      end

   root_node: MIXUP_NODE is
      do
         if not stack.is_empty then
            Result := stack.first
         end
      end

   reset is
      do
         stack.clear_count
         create position
         end_reached := False
      ensure
         stack.is_empty
         not end_reached
      end

feature {}
   epsilon: FAST_ARRAY[STRING] is
      once
         create Result.with_capacity(0)
      end

   last_blanks: STRING is ""
   comment_position: like position
   has_comment: BOOLEAN

   skip_blank (buffer: MINI_PARSER_BUFFER; skip_semi_colons: BOOLEAN): BOOLEAN is
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

   skip_blanks (buffer: MINI_PARSER_BUFFER) is
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

   parse_end (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE is
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

   parse_string (buffer: MINI_PARSER_BUFFER): TYPED_MIXUP_IMAGE[STRING] is
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
                  when '"' then
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
                  when '"' then
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

   parse_number (buffer: MINI_PARSER_BUFFER): MIXUP_IMAGE is
      local
         old_position, start_position: like position; state: INTEGER; c: CHARACTER; image: STRING
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
                        buffer.set_current_index(buffer.current_index - 1)
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
                     buffer.set_current_index(buffer.current_index - 1)
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

   is_hex (image: STRING): BOOLEAN is
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

   hex_to_integer_64 (image: STRING): INTEGER_64 is
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

   is_identifier_part (c: CHARACTER; string: STRING): BOOLEAN is
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

   identifier_filter: PREDICATE[TUPLE[CHARACTER, STRING]] is
      once
         Result := agent is_identifier_part
      end

   identifier_image (buffer: MINI_PARSER_BUFFER; filter: PREDICATE[TUPLE[CHARACTER, STRING]]): STRING is
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

   parse_identifier (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE is
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

   is_a_keyword (id: STRING): BOOLEAN is
      do
         inspect
            id
         when "book", "const", "end", "export", "false", "from", "import", "instrument", "lyrics", "module", "music", "partitur", "score", "set", "syllable", "true" then
            Result := True
         else
            check
               not Result
            end
         end
      end

   keyword_image (buffer: MINI_PARSER_BUFFER; keyword, not_successors: STRING): STRING is
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
               restore(buffer, old_position)
               Result := Void
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

   parse_keyword (buffer: MINI_PARSER_BUFFER; keyword: STRING): UNTYPED_MIXUP_IMAGE is
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

   parse_symbol (buffer: MINI_PARSER_BUFFER; keyword, not_successors: STRING): UNTYPED_MIXUP_IMAGE is
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

   parse_boolean (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE is
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         inspect
            buffer.current_character
         when 't' then
            image := keyword_image(buffer, once "true", Void)
         when 'f' then
            image := keyword_image(buffer, once "false", Void)
         else
            check image = Void end
         end
         if image /= Void then
            -- `image' may be shared here
            create Result.make(image, last_blanks.twin, start_position)
         else
            restore(buffer, old_position)
         end
      end

   parse_syllable (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE is
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         inspect
            buffer.current_character
         when '"', '\' then
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

   is_note_head_part (c: CHARACTER; string: STRING): BOOLEAN is
      do
         inspect
            string.count
         when 0 then
            inspect
               c
            when 'a' .. 'h' then
               Result := True
            else
               check not Result end
            end
         when 1 then
            inspect
               c
            when 'e', 'i', '%'', ',' then
               Result := True
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
         when 3 then
            inspect
               c
            when '%'', ',' then
               Result := True
            else
               check not Result end
            end
         else
            check not Result end
         end
      end

   note_head_filter: PREDICATE[TUPLE[CHARACTER, STRING]] is
      once
         Result := agent is_note_head_part
      end

   parse_note_head (buffer: MINI_PARSER_BUFFER): UNTYPED_MIXUP_IMAGE is
      local
         old_position, start_position: like position; image: STRING
      do
         old_position := position
         skip_blanks(buffer)
         start_position := position
         image := identifier_image(buffer, note_head_filter)
         if image /= Void and then image.count = 2 then
            inspect
               image.last
            when '%'', ',' then
               -- ok
            else
               image := Void
            end
         end
         if image /= Void and then not buffer.end_reached and then is_identifier_part(buffer.current_character, once "") then
            image := Void
         end
         if image = Void then
            restore(buffer, old_position)
         else
            if buffer.end_reached then
               end_reached := True
            end
            create Result.make(image, last_blanks.twin, start_position)
         end
      end

feature {}
   stack: FAST_ARRAY[MIXUP_NODE]

   show_stack is
      local
         i: INTEGER
      do
         std_error.put_line(once "--8<-------- <start stack>")
         from
            i := stack.lower
         until
            i > stack.upper
         loop
            std_error.put_integer(i)
            std_error.put_string(once ":%T")
            std_error.put_line(stack.item(i).name)
            i := i + 1
         end
         std_error.put_line(once "-------->8-- <end stack>")
      end

   stack_matches (node_content: TRAVERSABLE[FIXED_STRING]): BOOLEAN is
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

   build_non_terminal (node_name: FIXED_STRING; node_content: TRAVERSABLE[FIXED_STRING]) is
      require
         stack_matches(node_content)
      local
         i: INTEGER; new_node: MIXUP_NON_TERMINAL_NODE; node: MIXUP_NODE
      do
         debug ("parse/mixup/build")
            std_error.put_string(once "Building non-terminal node: ")
            std_error.put_character('"')
            std_error.put_string(node_name)
            std_error.put_character('"')
            std_error.put_new_line
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
               std_error.put_string(once "   aggregating: ")
               std_error.put_line(node_content.item(i))
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

   build_terminal (node_name: FIXED_STRING; node_image: PARSER_IMAGE) is
      local
         mixup_image: MIXUP_IMAGE
      do
         mixup_image ::= node_image
         debug ("parse/mixup/build")
            std_error.put_string(once "Building terminal node: ")
            std_error.put_character('"')
            std_error.put_string(node_name)
            std_error.put_string(once "%": ")
            std_error.put_line(mixup_image.image)
         end
         stack.add_last(factory.terminal(node_name, mixup_image))
         debug ("parse/mixup/build")
            show_stack
         end
      ensure
         stack.count = old stack.count + 1
         stack.last.name.is_equal(node_name)
      end

   build_empty_list (list_name: ABSTRACT_STRING) is
      local
         list: MIXUP_LIST_NODE
      do
         debug ("parse/mixup/build")
            std_error.put_string(once "Building new empty list %"")
            std_error.put_string(list_name)
            std_error.put_character('"')
            std_error.put_character('%N')
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

   build_new_list (atom_name, list_name: ABSTRACT_STRING) is
      require
         not stack.is_empty
         stack.last.name.is_equal(atom_name)
      local
         atom: MIXUP_NODE; list: MIXUP_LIST_NODE
      do
         atom := stack.last
         stack.remove_last
         debug ("parse/mixup/build")
            std_error.put_string(once "Building new list %"")
            std_error.put_string(list_name)
            std_error.put_string(once "%" with one atom: atom should be %"")
            std_error.put_string(atom_name)
            std_error.put_character('"')
            std_error.put_character('%N')
            std_error.put_string(once "   Found atom: ")
            std_error.put_line(atom.name)
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

   build_continue_list (atom_name: ABSTRACT_STRING; forget: INTEGER; list_name: ABSTRACT_STRING) is
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
            std_error.put_string(once "Building list %"")
            std_error.put_string(list_name)
            std_error.put_string(once "%" (continuation): atom should be %"")
            std_error.put_string(atom_name)
            std_error.put_character('"')
            std_error.put_character('%N')
            std_error.put_string(once "   Found list: ")
            std_error.put_line(list.name)
            std_error.put_string(once "   Found atom: ")
            std_error.put_line(atom.name)
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

feature {} -- buffer moves
   next_character (buffer: MINI_PARSER_BUFFER) is
      do
         position := position.next(buffer)
      end

   restore (buffer: MINI_PARSER_BUFFER; a_position: like position) is
      do
         position := a_position
         buffer.set_current_index(position.index)
      end

   position: MIXUP_POSITION

feature {}
   with_factory (a_factory: like factory) is
      do
         factory := a_factory
         create stack.make(0)
      ensure
         factory = a_factory
         stack.is_empty
      end

   default_create is
      do
         with_factory(create {MIXUP_DEFAULT_NODE_FACTORY}.make)
      end

   factory: MIXUP_NODE_FACTORY

invariant
   stack /= Void

end

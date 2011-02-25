expanded class MIXUP_POSITION

insert
   ANY
      redefine
         default_create, is_equal
      end

creation {MIXUP_GRAMMAR}
   default_create

feature {MIXUP_GRAMMAR}
   next (buffer: MINI_PARSER_BUFFER): like Current is
      do
         buffer.next
         index := buffer.current_index
         if not buffer.end_reached then
            inspect
               buffer.current_character
            when '%N' then
               line := line + 1
               column := 1
            when '%R' then
               -- ignored
            else
               column := column + 1
            end
         end
         Result := Current
      end

feature {MIXUP_GRAMMAR, MIXUP_IMAGE, MIXUP_POSITION}
   line: INTEGER
   column: INTEGER
   index: INTEGER

feature {ANY}
   is_equal (other: like Current): BOOLEAN is
      do
         Result := index = other.index
      end

feature {}
   default_create is
      do
         index := 1
         line := 1
         column := 1
      end

end -- class MIXUP_POSITION

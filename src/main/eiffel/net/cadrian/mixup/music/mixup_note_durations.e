expanded class MIXUP_NOTE_DURATIONS

feature {ANY}
   -- 64th
   duration_64  : INTEGER_64 is   4
   duration_64p : INTEGER_64 is   6
   duration_64pp: INTEGER_64 is   7

   -- 32th
   duration_32  : INTEGER_64 is   8
   duration_32p : INTEGER_64 is  12
   duration_32pp: INTEGER_64 is  14

   -- 16th
   duration_16  : INTEGER_64 is  16
   duration_16p : INTEGER_64 is  24
   duration_16pp: INTEGER_64 is  28

   -- crochet (or 8th)
   duration_8   : INTEGER_64 is  32
   duration_8p  : INTEGER_64 is  48
   duration_8pp : INTEGER_64 is  56

   -- quarter
   duration_4   : INTEGER_64 is  64
   duration_4p  : INTEGER_64 is  96
   duration_4pp : INTEGER_64 is 112

   -- half
   duration_2   : INTEGER_64 is 128
   duration_2p  : INTEGER_64 is 192
   duration_2pp : INTEGER_64 is 224

   -- whole
   duration_1   : INTEGER_64 is 256
   duration_1p  : INTEGER_64 is 384
   duration_1pp : INTEGER_64 is 448

end

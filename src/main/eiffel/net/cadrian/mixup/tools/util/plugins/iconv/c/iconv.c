/*
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
 */

// http://stackoverflow.com/a/11156490/47461

#include <iconv.h>

char *convert_chars(const char *source_format, const char *target_format, const char *source_data, int source_length) {
    iconv_t cd = iconv_open(target_format, source_format);
    char *result, *source_ptr, *target_ptr;
    int mult = 1;
    int cont = 0;

    while (!cont && mult <= 4) {
       size_t source_count = (size_t)source_length;
       size_t target_count = (size_t)source_length * mult;
       if (mult == 1) {
          result = target_ptr = malloc(target_count);
       } else {
          result = target_ptr = realloc(result, target_count);
       }
       source_ptr = (char*)source_data;

       cont = 1;
       do {
          if (iconv(cd, &source_ptr, &source_count, &target_ptr, &target_count) == (size_t) -1) {
             cont = 0;
          }
       } while (cont && source_count > 0 && target_count > 0);

       if (cont) {
          *target_ptr = 0;
       } else {
          mult *= 2;
       }
    }

    if (!cont) {
       free(result);
       result = NULL;
    }

    return result;
}

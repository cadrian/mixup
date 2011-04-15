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
class MIXUP
   --
   -- The program entry point.
   --

insert
   ARGUMENTS
   LOGGING

create {}
   make

feature {}
   mixer: MIXUP_MIXER_IMPL
   grammar: MIXUP_GRAMMAR

   make is
      local
         file: FIXED_STRING
      do
         create grammar
         create mixer.make(agent parse_file)
         create {LINKED_HASHED_DICTIONARY[DIRECTORY, FIXED_STRING]} load_paths.make

         configure
         if argument_count /= 1 then
            usage(log.error)
            die_with_code(1)
         end

         file := find_file(argument(1).intern, once ".mix")
         mixer.add_piece(parse(read_file(file)), file)

         mixer.play
      end

   usage (output: OUTPUT_STREAM) is
      do
         output.put_line("Usage: " + command_name + " <source>")
         output.put_new_line
         output.put_line("<source> is the name of the file containing the whole score.")
         output.put_new_line
      end

   configure is
      do
         set_load_paths
         set_log
         mixer.add_player(create {MIXUP_LILYPOND_PLAYER}.make)
         --mixer.add_player(create {MIXUP_MIDI_PLAYER}.make)
      end

   parse (a_source: MINI_PARSER_BUFFER): MIXUP_NODE is
      require
         a_source /= Void
      local
         evaled: BOOLEAN
      do
         grammar.reset
         evaled := grammar.parse(a_source)
         if not evaled then
            log.error.put_line("Could not parse the source file.")
            die_with_code(1)
         end
         Result := grammar.root_node
      ensure
         exists_or_dead: Result /= Void
      end

   read_file (a_file_name: FIXED_STRING): MINI_PARSER_BUFFER is
      require
         a_file_name /= Void
      local
         source: STRING
         tfr: TEXT_FILE_READ
      do
         create tfr.connect_to(a_file_name)
         if not tfr.is_connected then
            log.error.put_line("Could not open " + a_file_name.out + " for reading (not a regular file?)")
            die_with_code(1)
         end
         log.info.put_line("Reading " + a_file_name.out)
         from
            source := ""
         until
            tfr.end_of_input
         loop
            tfr.read_line
            source.append(tfr.last_string)
            source.extend('%N')
         end
         tfr.disconnect
         create Result
         Result.initialize_with(source)
      ensure
         exists_or_dead: Result /= Void
      end

   find_file (a_name: FIXED_STRING; a_suffix: STRING): FIXED_STRING is
      require
         a_name /= Void
      local
         name, path: STRING; dir: DIRECTORY
      do
         name := a_name.out
         if a_suffix /= Void and then not name.has_suffix(a_suffix) then
            name.append(a_suffix)
         end
         dir := load_paths.aggregate_items(agent find_file_in_dir(name, ?, ?), Void)
         if dir = Void then
            log.error.put_line("Could not find file: " + name)
            die_with_code(1)
         end
         path := dir.path.out
         system_notation.to_file_path_with(path, name)
         Result := path.intern
      ensure
         exists_or_dead: Result /= Void
      end

   find_file_in_dir (a_name: STRING; found_directory, a_directory: DIRECTORY): DIRECTORY is
      require
         a_name /= Void
         a_directory /= Void
      do
         if found_directory /= Void then
            Result := found_directory
         elseif a_directory.has_file(a_name) then
            Result := a_directory
         end
      end

   parse_file (a_name: FIXED_STRING): TUPLE[MIXUP_NODE, FIXED_STRING] is
      require
         a_name /= Void
      local
         file: FIXED_STRING
      do
         file := find_file(a_name, once ".mix")
         Result := [parse(read_file(file)), file]
      ensure
         exists_or_dead: Result /= Void
      end

feature {} -- Low-level files cuisine
   current_directory: DIRECTORY is
      once
         create Result.scan_current_working_directory
      ensure
         Result.exists
      end

   user_directory: DIRECTORY is
      once
         if home /= Void then
            create Result.scan(home)
         end
      end

   system_directory: DIRECTORY is
      once
         if system /= Void then
            create Result.scan(system)
         end
      end

   home: FIXED_STRING is
      local
         sys: SYSTEM
         userdir: STRING
      once
         userdir := sys.get_environment_variable("HOME")
         if userdir = Void then
            userdir := sys.get_environment_variable("PROFILE")
         end
         if userdir /= Void then
            system_notation.to_subdirectory_with(userdir, once ".mixup")
            Result := if_exists(userdir)
         end
      end

   system: FIXED_STRING is
      once
         Result := if_exists("/etc/mixup")
         if Result = Void then
            Result := if_exists("/usr/share/mixup")
         end
         if Result = Void then
            Result := if_exists("/usr/local/share/mixup")
         end
         if Result = Void then
            Result := if_exists("C:/Program Files/mixup")
         end
         if Result = Void then
            log.warning.put_line("Could not find the MiXuP installation directory.")
         end
      end

   if_exists (path: STRING): FIXED_STRING is
      local
         ft: FILE_TOOLS
      do
         if not system_notation.is_valid_path(path) then
            system_notation.from_notation(internal_notation, path)
         end
         if ft.file_exists(path) and then ft.is_directory(path) then
            Result := path.intern
         end
      end

   internal_notation: UNIX_DIRECTORY_NOTATION is
      once
         create Result
      end

   system_notation: DIRECTORY_NOTATION is
      local
         bd: BASIC_DIRECTORY
      once
         bd.connect_to_current_working_directory
         if bd.is_connected then
            bd.disconnect
            Result := bd.system_notation
         end
         if Result = Void then
            log.error.put_line("Could not detect your operating system.")
            log.error.put_line("Please drop a hint to <cyril.adrian@gmail.com>")
            die_with_code(1)
         end
      end

feature {} -- Logs
   set_log is
      local
         logrc: FIXED_STRING
         conf: LOG_CONFIGURATION
      once
         logrc := find_file("log.rc".intern, Void)
         if logrc /= Void then
            conf.load(create {TEXT_FILE_READ}.connect_to(logrc), agent on_log_error, Void)
         end
      end

   on_log_error (msg: STRING) is
      do
         log.error.put_line(msg)
         die_with_code(1)
      end

feature {} -- Load paths
   set_load_paths is
      do
         load_paths.clear_count
         add_load_path(current_directory)
         if user_directory /= Void then
            add_load_path(user_directory)
            set_load_paths_from(user_directory)
         end
         if system_directory /= Void then
            add_load_path(system_directory)
            set_load_paths_from(system_directory)
         end
      end

   set_load_paths_from (a_directory: DIRECTORY) is
      local
         input: INPUT_STREAM
         path: FIXED_STRING
         dir: DIRECTORY
      do
         if a_directory.has_file(once "load_paths") then
            from
               input := a_directory.file(once "load_paths").as_regular.read
            until
               input.end_of_input
            loop
               input.read_line
               if not input.last_string.is_empty then
                  path := input.last_string.intern
                  if not load_paths.fast_has(path) then
                     create dir.scan(path)
                     if dir.exists then
                        add_load_path(dir)
                     end
                  end
               end
            end
         end
      end

   add_load_path (a_dir: DIRECTORY) is
      require
         a_dir.exists
      do
         load_paths.add(a_dir, a_dir.path)
      end

   load_paths: DICTIONARY[DIRECTORY, FIXED_STRING]

invariant
   load_paths /= Void

end -- class MIXUP

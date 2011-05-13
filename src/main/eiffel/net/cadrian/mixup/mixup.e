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
   mixup_suffix: STRING is ".mix"

   mixer: MIXUP_MIXER
   grammar: MIXUP_GRAMMAR

   make is
      local
         file: FILE
      do
         create grammar
         create mixer.make(agent parse_file)
         create {LINKED_HASHED_DICTIONARY[DIRECTORY, FIXED_STRING]} load_paths.make

         configure
         if argument_count /= 1 then
            usage(log.error)
            die_with_code(1)
         end

         open_directory := current_directory
         file := find_file(argument(1).intern, mixup_suffix)
         mixer.add_piece(parse(read_file(file)), file.path)
         check
            open_directory = current_directory
         end

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
      end

   parse (a_source: MINI_PARSER_BUFFER): MIXUP_NODE is
      require
         a_source /= Void
      local
         evaled: BOOLEAN
         error: PARSE_ERROR
      do
         grammar.reset
         evaled := grammar.parse(a_source)
         if not evaled then
            log.error.put_line("Incomplete source file.")
            die_with_code(1)
         end
         Result := grammar.root_node
         if Result = Void then
            log.error.put_line("Could not parse the source file.")
            from
               error := grammar.parse_error
            until
               error = Void
            loop
               log.error.put_line(error.message + " (@" + error.index.out + ")")
               error := error.next
            end
            die_with_code(1)
         end
      ensure
         exists_or_dead: Result /= Void
      end

   open_directory: DIRECTORY

   read_file (a_file: FILE): MINI_PARSER_BUFFER is
      require
         a_file /= Void
      local
         source: STRING
         input: INPUT_STREAM
      do
         if not a_file.is_regular then
            log.error.put_line("Could not open " + a_file.path.out + " for reading (is it a directory?)")
            die_with_code(1)
         end
         input := a_file.as_regular.read
         if input = Void or else not input.is_connected then
            log.error.put_line("Could not open " + a_file.path.out + " for reading (is it a regular file?)")
            die_with_code(1)
         end
         log.info.put_line("Reading " + a_file.path.out)
         from
            source := ""
         until
            input.end_of_input
         loop
            input.read_line
            source.append(input.last_string)
            source.extend('%N')
         end
         input.disconnect
         create Result
         Result.initialize_with(source)
      ensure
         exists_or_dead: Result /= Void
      end

   find_file (a_name: FIXED_STRING; a_suffix: STRING): FILE is
      require
         a_name /= Void
      local
         name: STRING
         file_finder: AGGREGATOR[DIRECTORY, FILE]
      do
         name := a_name.out
         if a_suffix /= Void and then not name.has_suffix(a_suffix) then
            name.append(a_suffix)
         end
         Result := file_finder.map(load_paths,
                                   agent find_file_in_dir(name.intern, ?, ?),
                                   find_file_in_dir(name.intern, open_directory, Void))
         if Result = Void then
            log.error.put_line("Could not find file: " + name)
            die_with_code(1)
         end
      ensure
         exists_or_dead: Result /= Void
      end

   find_file_in_dir (a_name: FIXED_STRING; a_directory: DIRECTORY; found_file: FILE): FILE is
      require
         a_name /= Void
         a_directory /= Void
      local
         dot_index: INTEGER
         dirname, basename: FIXED_STRING
         dir: DIRECTORY
      do
         if found_file /= Void then
            Result := found_file
         elseif a_directory.has_file(a_name) then
            Result := a_directory.file(a_name)
            open_directory := a_directory
         else
            dot_index := a_name.first_index_of('.')
            if dot_index < a_name.upper - 4 then -- because the last dot belongs to the ".mix" suffix
               dirname := a_name.substring(a_name.lower, dot_index - 1)
               if a_directory.has_file(dirname) and then a_directory.file(dirname).is_directory then
                  dir := a_directory.file(dirname).as_directory
                  basename := a_name.substring(dot_index + 1, a_name.upper)
                  log.info.put_line(a_name + ": looking for " + basename + " in " + dir.path)
                  Result := find_file_in_dir(basename, dir, Void)
               end
            end
         end
      end

   parse_file (a_name: FIXED_STRING): TUPLE[MIXUP_NODE, FIXED_STRING] is
      require
         a_name /= Void
      local
         file: FILE
         old_directory: like open_directory
      do
         old_directory := open_directory
         file := find_file(a_name, mixup_suffix)
         Result := [parse(read_file(file)), file.path]
         open_directory := old_directory
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
         logrc: FILE
         conf: LOG_CONFIGURATION
      once
         open_directory := current_directory
         logrc := find_file("log.rc".intern, Void)
         if logrc /= Void and then logrc.is_regular then
            conf.load(logrc.as_regular.read, agent on_log_error, Void)
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

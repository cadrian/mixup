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
   MIXUP_CONFIGURATION
   LOGGING

create {}
   make

feature {}
   mixup_suffix: STRING is ".mix"

   mixer: MIXUP_MIXER
   grammar: MIXUP_GRAMMAR

   make is
      do
         create grammar
         create mixer.make(agent parse_file)
         create {LINKED_HASHED_DICTIONARY[DIRECTORY, FIXED_STRING]} load_paths.make

         configure(agent when_configured)

         log.info.put_line(once "Done.")
      end

   when_configured is
      local
         file: FILE
      do
         if not args.parse_command_line then
            usage(log.error)
            die_with_code(1)
         end

         if lilypond_exe.is_set then
            lilypond_exe_path.set_item(lilypond_exe.item.path)
         end
         if lilypond_include.is_set then
            lilypond_include_directories.add_last(lilypond_include.item.path)
         end

         open_directory := current_directory
         file := find_file(mix_file.item, mixup_suffix)
         mixer.add_piece(parse(file.path, read_file(file)), file.path)
         check
            open_directory = current_directory
         end

         mixer.play
      end

   usage (output: OUTPUT_STREAM) is
      do
         args.usage(output)
      end

   configure (a_when_configured: PROCEDURE[TUPLE]) is
      do
         set_paths
         set_log(a_when_configured)
      end

   parse (a_path: ABSTRACT_STRING; a_source: MINI_PARSER_BUFFER): MIXUP_NODE is
      require
         a_path /= Void
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
               log.error.put_string(a_path.out)
               log.error.put_string(once ":")
               log.error.put_integer(error.index)
               log.error.put_string(once ": ")
               log.error.put_line(error.message)
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
            log.error.put_string(once "Could not open ")
            log.error.put_line(a_file.path)
            log.error.put_line(once " for reading (is it a directory?)")
            die_with_code(1)
         end
         input := a_file.as_regular.read
         if input = Void or else not input.is_connected then
            log.error.put_string(once "Could not open ")
            log.error.put_string(a_file.path)
            log.error.put_line(once " for reading (is it a regular file?)")
            die_with_code(1)
         end
         log.info.put_string(once "Reading ")
         log.info.put_line(a_file.path)
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
            log.error.put_string(once "Could not find file: ")
            log.error.put_line(name)
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
                  log.info.put_string(a_name)
                  log.info.put_string(once ": looking for ")
                  log.info.put_string(basename)
                  log.info.put_string(once " in ")
                  log.info.put_line(dir.path)
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
         Result := [parse(file.path, read_file(file)), file.path]
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
      local
         mixup_dir, candidate: STRING
         sys: SYSTEM
         possible_directories: LINKED_LIST[STRING]
         i: ITERATOR[STRING]
      once
         possible_directories := {LINKED_LIST[STRING] <<
                                                        "/etc/mixup",
                                                        "/usr/share/mixup",
                                                        "/usr/local/share/mixup",
                                                        "C:\Program Files\mixup\system"
                                                        >> }

         mixup_dir := sys.get_environment_variable("MIXUP_DIR")
         if mixup_dir /= Void then
            possible_directories.add_first(mixup_dir)
         end

         from
            i := possible_directories.new_iterator
         until
            Result /= Void or else i.is_off
         loop
            candidate := i.item
            Result := if_exists(candidate)
            i.next
         end

         if Result = Void then
            log.warning.put_line("Could not find the MiXuP installation directory.")
         else
            log.info.put_string("Using MiXuP installation directory: ")
            log.info.put_line(Result)
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
   set_log (a_when_configured: PROCEDURE[TUPLE]) is
      local
         logrc: FILE
         conf: LOG_CONFIGURATION
      once
         open_directory := current_directory
         logrc := find_file("log.rc".intern, Void)
         if logrc /= Void and then logrc.is_regular then
            conf.load(logrc.as_regular.read, agent on_log_error, Void, agent disconnect_log_and_call(logrc, a_when_configured))
         else
            a_when_configured.call([])
         end
      end

   on_log_error (msg: STRING) is
      do
         log.error.put_line(msg)
         die_with_code(1)
      end

   disconnect_log_and_call (logrc: FILE; a_when_configured: PROCEDURE[TUPLE]) is
      do
         logrc.as_regular.read.disconnect
         a_when_configured.call([])
      end

feature {} -- Load paths
   set_paths is
      do
         if user_directory /= Void then
            set_path(user_directory)
         end
         if system_directory /= Void then
            set_path(system_directory)
         end
      end

   set_path (a_directory: DIRECTORY) is
      require
         a_directory.exists
      do
         add_load_path(a_directory)
         set_paths_from(a_directory, once "load_paths", agent add_load_path)
         add_lilypond_include_directory(a_directory)
         set_paths_from(a_directory, once "lilypond_include_paths", agent add_lilypond_include_directory)
      end

   add_load_path (a_directory: DIRECTORY) is
      require
         a_directory.exists
      do
         load_paths.add(a_directory, a_directory.path)
      end

   load_paths: DICTIONARY[DIRECTORY, FIXED_STRING]

   add_lilypond_include_directory (a_directory: DIRECTORY) is
      require
         a_directory.exists
      do
         lilypond_include_directories.add_last(a_directory.path)
      end

feature {}
   set_paths_from (a_directory: DIRECTORY; a_file_name: STRING; a_path_setter: PROCEDURE[TUPLE[DIRECTORY]]) is
      local
         input: INPUT_STREAM
         path: FIXED_STRING
         dir: DIRECTORY
      do
         if a_directory.has_file(a_file_name) then
            from
               input := a_directory.file(a_file_name).as_regular.read
            until
               input.end_of_input
            loop
               input.read_line
               if not input.last_string.is_empty then
                  path := input.last_string.intern
                  if not load_paths.fast_has(path) then
                     create dir.scan(path)
                     if dir.exists then
                        a_path_setter.call([dir])
                     end
                  end
               end
            end
            input.disconnect
         end
      end

feature {} -- arguments
   arg_factory: COMMAND_LINE_ARGUMENT_FACTORY

   mix_file: COMMAND_LINE_TYPED_ARGUMENT[FIXED_STRING] is
      once
         Result := arg_factory.positional_string("mixfile", "The MiXuP file to read")
      end

   lilypond_exe: COMMAND_LINE_TYPED_ARGUMENT[REGULAR_FILE] is
      once
         Result := arg_factory.option_file("y", "lilypond_exe", "lilypond_exe", "The lilypond executable path")
      end

   lilypond_include: COMMAND_LINE_TYPED_ARGUMENT[DIRECTORY] is
      once
         Result := arg_factory.option_directory("I", "lilypond_include", "lilypond_include", "The lilypond include directory")
      end

   args: COMMAND_LINE_ARGUMENTS is
      once
         create Result.make(lilypond_exe and lilypond_include and mix_file)
      end

invariant
   load_paths /= Void

end -- class MIXUP

require 'test_helper'

module Byebug
  #
  # Tests standalone byebug when flags that require no target program are used
  #
  class RunnerWithoutTargetProgramTest < TestCase
    def test_run_with_version_flag
      stdout = run_program('bin/byebug --version')

      assert_match(/Running byebug 9.0.6/, stdout)
    end

    def test_run_with_help_flag
      stdout = run_program('bin/byebug --help')

      expected_stdout = <<-TEXT.gsub(/^ {6}/, '')

        byebug 9.0.6

        Usage: byebug [options] <script.rb> -- <script.rb parameters>

          -d, --debug               Set $DEBUG=true
          -I, --include list        Add to paths to $LOAD_PATH
          -m, --[no-]post-mortem    Use post-mortem mode
          -q, --[no-]quit           Quit when script finishes
          -x, --[no-]rc             Run byebug initialization file
          -s, --[no-]stop           Stop when script is loaded
          -r, --require file        Require library before script
          -R, --remote [host:]port  Remote debug [host:]port
          -t, --[no-]trace          Turn on line tracing
          -v, --version             Print program version
          -h, --help                Display this message

      TEXT

      assert_equal expected_stdout, stdout
    end

    def test_run_with_remote_option_only_with_a_port_number
      stdout = run_program('bin/byebug --remote 9999')

      assert_match(/Connecting to byebug server at localhost:9999.../, stdout)
    end

    def test_run_with_remote_option_with_host_and_port_specification
      stdout = run_program('bin/byebug --remote myhost:9999')

      assert_match(/Connecting to byebug server at myhost:9999.../, stdout)
    end

    def test_run_without_a_script_to_debug
      stdout = run_program('bin/byebug')

      assert_match(/\*\*\* You must specify a program to debug/, stdout)
    end

    def test_run_with_an_nonexistent_script
      stdout = run_program('bin/byebug non_existent_script.rb')

      assert_match(/\*\*\* The script doesn't exist/, stdout)
    end

    def test_run_with_an_invalid_script
      example_file.write('[1,2,')
      example_file.close

      stdout = run_program("bin/byebug #{example_path}")

      assert_match(/\*\*\* The script has incorrect syntax/, stdout)
    end
  end
end
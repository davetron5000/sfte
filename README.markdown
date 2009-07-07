# *S*ur*f*ire *T*est *E*rrors

This runs maven and, if there are test failures, produces output suitable for vim "quickfix" mode stepthrough.  This has only been used with JUnit; TestNG is likely a different beast

# Install

    sudo gem install davetron5000-sfte

# Usage

Set up your `.vimrc` or some file it includes with:

    let &makeprg="sfte mvn -d test -v very -f /path/to/your/pom.xml"

Modify your `maven2.vim` compiler plugin as so:

    CompilerSet errorformat=
        \%[%^[]%\\@=%f:%l:\ %m,
        \%A%[%^[]%\\@=%f:[%l\\,%v]\ %m,
        \%-Clocation\ %#:%.%#,
        \%C%[%^:]%#%m,
        \%-G%.%#,
        \%-Z\ %#

The first line of that is what I added to get the errors to show up, so if you have a more sophisticated `errorformat`, that's what you need to add.

Now, when you do a `:make` from vim, test failures will output like compile errors and you can step through in quickfix mode.

# Customizing

You will probably need to set the `-p` option to `sfte`, as this indicates a Java package-prefix for your codebase.  So, if you work example.com, you'd probably need

    sfte -p com.example mvn

    usage: sfte command [options]

    Options:
        -p, --prefix=a class package-style prefix - Classname prefix that indicates 
                                                    YOUR code (default: pos)

    Commands:
        cat  - Extracts useful info from surefire test output
        efm  - Outputs the given surfire text files as vim-efm lines for stepthrough
        help - Shows list of commands or help for one command
        mvn  - Run mvn

## mvn

This is the command you'll run from vim.

    mvn [options] Maven command line
        Run mvn

    Options:
        -d maven target                        - Default target (default: 
                                                 test-compile)
        -f full path to pom file               - Specify the pom file
        -v, --verbose="very" or something else - Show maven output

## cat

Parse out only the relevant bits of a Surefire error report

cat [options] The name of the test that failed, from maven output (not filename)
    Extracts useful info from surefire test output

Options:
    -a, --all         - Show the entire file instead of relevant parts
    -b, --basedir=arg - Override the base dir, when looking for the file 
                        (default: .)

This can be useful if you ran tests on the command line and don't want to slog through the output looking for what's relevant.

## efm

This  allows you to parse any Surefire plugin test output and translate it into usable output on the command line (this is used by `mvn` if there are test failures


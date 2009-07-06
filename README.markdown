# Overview

This is a runner for the maven "build" "tool" that works with the Surefire test plugin to ultimatley allow you to surface test errors in standard output in a way suitable for stepping through via Vim.

# Setup

1. Sorry, no gem yet; just check this out and put the `bin` dir in your path.
1. Set up your `.vimrc` or some file it includes with:
    let &makeprg="sfte mvn -d test -v very -f /path/to/your/pom.xml . " "
1. Modify your `maven2.vim` compiler plugin as so:
    CompilerSet errorformat=
        \%[%^[]%\\@=%f:%l:\ %m,
        \%A%[%^[]%\\@=%f:[%l\\,%v]\ %m,
        \%-Clocation\ %#:%.%#,
        \%C%[%^:]%#%m,
        \%-G%.%#,
        \%-Z\ %#

The first line of that is what I added to get the errors to show up, so if you need a more complicated `errorformat`, that's what you need to add.

Now, when you do a `:make` from vim, test failures will output like compile errors and you can step through

# Customizing

You will probably need to set the `-p` option to `sfte`, as this indicates a Java package-prefix for your codebase.  So, if you work example.com, you'd probably need
    sfte -p com.example mvn

A `sfte help` will show you the commands and `sfte help command_name` will dig deeper.



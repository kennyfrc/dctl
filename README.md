# DCTL(1) - General Commands Manual

## NAME

**dctl** - daemon control wrapper that handles paths and prints PIDs

## SYNOPSIS

**dctl** [*daemon-options*] [**--**] *command* [*args...*]

## MOTIVATION

When running servers in Claude Code, it hangs with any server invocation, with `nohup ... &`, etc. Daemon control allows it to run in the background as a daemon process.

## DESCRIPTION

**dctl** is a wrapper around the daemon(1) command that simplifies daemon management by automatically handling relative paths, generating default names, setting up log files, and printing the daemon's PID to stdout for easy capture.

The **dctl** utility converts relative paths to absolute paths for commands, working directories, log files, and PID files, making it easier to start daemons from any location. It also provides sensible defaults for daemon names and output logs when not explicitly specified.

## OPTIONS

**dctl** accepts all options supported by daemon(1). Common options include:

**-n**, **--name** *name*  
Specify a name for the daemon. If not provided, a unique name is automatically generated.

**-D**, **--chdir** *directory*  
Change to this directory before running the command. Defaults to the current directory.

**-o**, **--output** *file*  
Redirect both stdout and stderr to this file. Defaults to *name*.log in the current directory.

**-F**, **--pidfile** *file*  
Specify the PID file location. Defaults vary by user privileges and OS.

**-f**, **--foreground**  
Run the daemon in the foreground (do not detach).

**-r**, **--respawn**  
Restart the daemon if it dies.

**-v**, **--verbose**  
Be verbose about what is happening.

**--**  
Marks the end of daemon options and the beginning of the command to run.

For a complete list of options, see daemon(1).

## EXIT STATUS

**dctl** exits with the same status code as the underlying daemon(1) command:

**0**  
The daemon was successfully started.

**1**  
An error occurred.

## EXAMPLES

Start a simple Python HTTP server as a daemon:

    dctl python3 -m http.server 8080

Start a daemon with a specific name and log file:

    dctl -n myserver -o /var/log/myserver.log python3 app.py

Run a script from a relative path:

    dctl ./scripts/monitor.sh

Start a daemon that respawns if it crashes:

    dctl -r -n webapp node server.js

Run in foreground for debugging:

    dctl -f python3 debug_server.py

## INSTALLATION

### From Source

    make install              # Install to /usr/local/bin
    make install PREFIX=~/.local  # Install to ~/.local/bin
    make symlink              # Create development symlink

### Package Managers

macOS (Homebrew):

    brew install daemon       # Install dependency
    make install

Ubuntu/Debian:

    sudo apt-get install daemon
    sudo make install

Fedora/RHEL:

    sudo dnf install daemon
    sudo make install

## FILES

**/usr/local/bin/dctl**  
Default installation location.

**/var/run/*name*.pid**  
Default PID file location for root user.

**/tmp/*name*.pid**  
Default PID file location for regular users.

**./*name*.log**  
Default log file location (current directory).

## ENVIRONMENT

**PATH**  
Used to locate the daemon command and the command to be daemonized.

## FEATURES

- Automatic PID printing to stdout for easy capture
- Intelligent path resolution for commands and files
- Automatic name generation when not specified
- Platform-aware default PID file locations
- Sensible defaults for working directory and log files

## SEE ALSO

daemon(1), systemd(1), launchd(8), start-stop-daemon(8)

## BUGS

Report bugs at: https://github.com/kennyfrc/dctl/issues

## LICENSE

MIT License - see [LICENSE](LICENSE) file for details.


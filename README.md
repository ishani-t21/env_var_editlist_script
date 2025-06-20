# env_var_editlist_script
A POSIX-compliant shell script designed to provide robust and flexible manipulation of environment variables that use a separator-based list format—such as PATH, LD_LIBRARY_PATH, or other user-defined variables. These variables typically store multiple directory or value entries separated by characters like : or ;, and managing them manually can be error-prone and time-consuming.


This script offers a user-friendly command-line interface that supports four core operations:
| Flag   | Description                                    |
|--------|------------------------------------------------|
| `-l`   | List entries in the selected environment variable |
| `-a`   | Append new entries                              |
| `-p`   | Prepend new entries                             |
| `-d`   | Delete existing entries                         |
| `-e VAR` | Specify the environment variable to edit (default: `PATH`) |
| `-s SEP` | Set a custom separator (default: `:`)         |

> **Note:** Only one of `-l`, `-a`, `-p`, or `-d` can be used per command.

### Usage

```sh
source ./editlist.sh
editlist [ -l | -a | -p | -d ] [-e VAR] [-s SEP] [arg1 arg2 ...]
```

### Examples

`#` List entries in $PATH
editlist -l

`#` Append directories to $PATH
editlist -a /opt/myapp/bin /home/user/scripts

`#` Prepend entries to $LD_LIBRARY_PATH using a custom separator
editlist -p -e LD_LIBRARY_PATH -s : /usr/local/lib64

`#` Delete an entry from $PATH
editlist -d /usr/local/bin

### Input Validation
- Entries containing the specified separator (e.g., :) will trigger an error.
- The script prevents adding malformed input or unsafe strings.
- Deletions are performed exactly (-x match in grep) to avoid accidental removal of substrings.

# open_with_primary_keyboard
`open_with_primary_keyboard.sh` and the helper `open_with_neo_keyboard.sh` are workarounds for one, or actually two, bugs around keyboard layouts.

## The problem
The VMWare Horizon remote desktop client has a bug where opening a remote desktop connection, the ctrl key is broken on the host. It doesn't activate under any circumstances, thereby breaking A LOT of keyboard shortcuts. This does not happen if your primary keyboard layout is QWERTY or QWERTZ.
However, the NEO keyboard layout has additional layers activated through modifiers that don't work if your primary layout is QWERTZ. They do work if you set QWERTZ in the T3 variant as the primary layout. You don't need to have it be the active layout, just the first in the list. So, using the T3 variant works around VMWare's bug, but it surfaces bugs in other programs that also treat the first keyboard layout special in some way.

The Keepass2 client doesn't use the active keyboard layout for key shortcuts but instead the primary keyboard. This is queried on startup. If you start keepass2 while QWERTZ is the primary layout, those keybinds will not change anymore regardless of what layout you switch to. It does not change either if you set a different primary layout unless you restart keepass2.

VS Code has the exact same bug (https://github.com/microsoft/vscode/issues/24166). There exists a workaround but with unclear side-effects.

## The solution
As the programs only quey the primary keyboad layout on startup, the solution is simple: Switch the primary keyboard layout on startup, then switch back.

These scripts do just that. I've added wrappers for the affected programs that override the original executables and desktop files in these locations:

* `~/bin/`  for binaries so it works in the terminal.
  There is a generic wrapper in this repo called `run_exe_with_neo_keyboard_wrapper.sh`. This can be copied and renamed to the same name as the executable to be wrapped. It will figure out what to call from its own name. It just needs to be placed somewhere on the PATH before the actual executable.  
* `~/.local/share/applications` so it works with GUI application shortcuts in Gnome

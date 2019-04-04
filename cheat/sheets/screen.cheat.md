## Getting in
- `screen -S <name>`  start a new screen session with session name
- `sceen -ls`         list running sessions/screens
- `screen -x`         attach to a running session
- `sceen -r <name>`   attach to a running session with name
- `screen -d <name>`  detach a running session

"ultimate attach" (attach, detaching any other attached display, if no session
exists one is created):

    screen -dRR


## Escape key
- `C-a`         all comands are prefixed by Ctrl-a

## Getting out
- `C-a d`       detach
- `C-a D D`     detach and logout (quick exit)
- `C-a \`       exit screen (exit all of the programs in screen)
- `C-a C-\`     force-exit screen (not recommended)

## Help
- `C-a ?`       view help

## Window Management
- `C-a c`                     create new window
- `C-a C-a`                   change to last-visited active window
- `C-a <number>`              change to window by number (only for windows 0 to 9)
- `C-a ' <number or title>`   change to window by number or name
- `C-a n` *or* `C-a <space>`  change to next window in list
- `C-a p` *or* `C-a <backsp>` change to previous window in list
- `C-a "`                     window list (select a window to change to)
- `C-a w`                     show window bar (if you don't have window bar)
- `C-a k`                     kill current window (not recommended)
- `C-a \`                     kill all windows (not recommended)
- `C-a A`                     rename current window

## Navigation
- `C-a <esc>`       Enter copy/scrollback buffer mode

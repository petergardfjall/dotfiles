## tmux commands for session management
- `tmux new -s debug`          # create and attach to a new named session
- `tmux ls`                    # list available sessions
- `tmux attach -t debug`       # attach to an existing target session

## in-session shortcuts
- `C-b d`                      # detach from session
- `C-b c`                      # create additional window
- `exit/ctrl-d`                # exit pane/window (last win => destroy session)
- `C-b %`                      # split window horizontally into two panes
- `C-b "`                      # split window vertically into two panes
- `C-b <arrow>`                # move between window panes
- `C-b <digit>`                # move between windows
- `C-b <PgUp>`                 # enter "scroll mode" ('q' to exit)

## copy mode
- `C-b [`                      # enter copy mode
- `C-space`                    # start selection
- `<arrow keys>`               # move selection
- `alt-w`                      # copy
- `C-b ]`                      # paste/yank most recent selection


## synchronize panes (send input to every pane)
- `C-b :set synchronize-panes on`   # turn sync on
- `C-b :set synchronize-panes off`  # turn sync off

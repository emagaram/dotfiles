
#!/bin/sh

get_session_name() {
  basename "$(pwd)"
}

session_name=$(get_session_name)
if tmux has-session -t "$session_name" 2>/dev/null; then
  echo "Attaching to existing session: $session_name"
  tmux attach -t "$session_name"
else
  echo "Creating new session: $session_name"
  cd "$(pwd)"
  tmux new-session -s "$session_name"
fi


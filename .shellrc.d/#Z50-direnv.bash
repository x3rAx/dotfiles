#eval "$(direnv hook bash)"


_direnv_hook() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$("/nix/store/a96ybrx7yh1yjqwg8i083gbnwdmwhq4l-direnv-2.21.3/bin/direnv" export bash)";
  trap - SIGINT;
  return $previous_exit_status;
};
if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

bla() {
  return 1
}

__prompt_command_fix() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;

  echo a
  _trueline_prompt_command
  echo b
  _direnv_hook
  echo c


  trap - SIGINT;
  return $previous_exit_status;
}
if ! [[ "${PROMPT_COMMAND:-}" =~ __prompt_command_fix ]]; then
  __ORIG_PROMPt_COMMAND="${PROMPT_COMMAND}"
  PROMPT_COMMAND="__prompt_command_fix"
fi

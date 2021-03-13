"""Unit tests: yadm.[git,gpg]-program"""

import os
import pytest


@pytest.mark.parametrize(
    'executable, success, value, match', [
        (None, True, 'program', None),
        ('cat', True, 'cat', None),
        ('badprogram', False, None, 'badprogram'),
    ], ids=[
        'executable missing',
        'valid alternative',
        'invalid alternative',
    ])
@pytest.mark.parametrize('program', ['git', 'gpg'])
def test_x_program(
        runner, yadm_cmd, paths, program, executable, success, value, match):
    """Set yadm.X-program, and test result of require_X"""

    # set configuration
    if executable:
        os.system(' '.join(yadm_cmd(
            'config', f'yadm.{program}-program', executable)))

    # test require_[git,gpg]
    script = f"""
        YADM_TEST=1 source {paths.pgm}
        YADM_OVERRIDE_CONFIG="{paths.config}"
        configure_paths
        require_{program}
        echo ${program.upper()}_PROGRAM
    """
    run = runner(command=['bash'], inp=script)
    assert run.success == success

    # [GIT,GPG]_PROGRAM set correctly
    if value == 'program':
        assert run.out.rstrip() == program
    elif value:
        assert run.out.rstrip() == value

    # error reported about bad config
    if match:
        assert match in run.err
    else:
        assert run.err == ''

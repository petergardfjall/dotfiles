### Pipenv

Make pipenv create virtualenvs in the project dir instead of under
`~/.local/share/virtualenvs/`.

    PIPENV_VENV_IN_PROJECT=true

Create a venv for python3. Creates an empty Pipfile if none exists.

    pipenv --three

Add dependency to Pipfile.

    pipenv install Jinja2
    # with specific version
    pipenv install requests==2.10

Add local project dir (as editable) to Pipfile.  Adding project dir itself
("editable") to PYTHONPATH is useful during development.  Also, for a pipenv
client of the package, this means that `pipenv install <project-dir>` will also
include what's specified in setup.py (if anything), such as console_scripts.

    pipenv install '-e .'

Enter sub-shell for the virtualenv.

    pipenv shell

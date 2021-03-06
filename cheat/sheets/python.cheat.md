# Packaging
A python *package* is a code directory structure (containing a `__init__.py`),
with each py file in that structure being a *module*. Each `module.py` can be
included into code via an `import package.path.to.module` statement.

A package is installed by copying the directory structure to a directory on the
`PYTHONPATH` (`sys.path`).

- project: library or application intended to be packaged in to a
  *distribution*. A project can have multiple releases.

- *distribution*: a versioned archive for a Python package that can be
  downloaded and installed (e.g. from a package index). There can be several
  distributions for a release. Commonly:
  - `sdist`: a `tar.gz` source distribution for a package. Needs to be built
    before being installed (generated via `python setup.py sdist`). Provides
    metadata and source files needed by an installation tool like `pip` or for
    generating a `bdist`. For pure python-code package that doesn't rely on
    non-python code, only an `sdist` distribution is necessary. To avoid the
    need to build a package with non-python code, pre-built `bdist`
    distributions can be published.
  - `bdist_wheel`: a *built distribution*. `wheel` is the prefered format (over
    `egg`) and is supported by `pip`. A built distribution can be installed by
    just moving it to the right location on the target system. While `wheel` is
    such a format `distutils`' `sdist` format is not as it needs to be built
    before being installed. A `wheel` can include compiled components built with
    other languages. Depending on reliance on native code and such, each `bdist`
    may target a specific combination of: python version (`3.5`), platform/os
    (`linux`/`macosx`/`win32`/`win_amd64`), python implementation (`cpython`).

- *package index*: a repository of package distributions offering discovery and
  consumption. PyPi (`pypi.org`) is the default index for the python community.
  See https://warehouse.pypa.io/api-reference/json/

- `setup.py`: project specification file found at root of a project. Used by
  `distutils` and `setuptools`. Its `install_requires` is read by `pip` when
  installing the package (and its dependencies). Whenevery you need to
  distribute your code as a _library_, you need to include a `setup.py` for
  `pip` to install the package. When you build an _application_, you might not
  need a `setup.py`, for example a `Pipfile[.lock]` could suffice.

- `distutils`: the original python packaging system. Direct use of it is
  discouraged. `setuptools` is now preferred.

- `setuptools`: enhancement to `distutils` that simplifies building and
  publishing of distributions with dependencies on other packages.

- `wheel`: a *built distribution* format introduced by `setuptools`. `egg` is an
  old format superceded by `wheel`.

- `pip`: python's recommended package (or rather distribution) installer. when
  installing from PyPi `pip install <name>`, `pip` can install both sdists and
  wheels, but prefer wheels. `pip` doesn't have true dependency resolution, but
  uses the first specification found for a package. When `pip install` runs it
  *only* installs dependencies declared in `install_requires` in `setup.py`.

  - `requirements.txt`: lists items to be installed via `pip install -r <file>`.
    Installation order is undefined. Typically used to (1) `pip freeze` to
    produce repeatable installations (for dev environments), (2) force pip to
    properly resolve deps, (3) override some dep with a locally patched
    version. For libraries, `setup.py` is used to, via `install_requires` tell
    `pip` what dependencies are needed. These versions should not be pinned but
    be as wide as possible. Version pinning, as specified in `requirements.txt`
    should only be used for apps or repeatable builds.

- `virtualenv`: a tool to create isolated python environments, with separate
  binaries and python path directories. Install anything within the virtual env
  without polluting the global (system-wide) installation.

- `pipenv`: a dependency manager for Python that combines the use of `pip` and
  `virtualenv`. It manages a `virtualenv` for your project, adds/removes
  packages from your `Pipfile`, and can generate a `Pipfile.lock` to produce
  deterministic builds. Note that `setup.py` vs `Pipfile` is not an either or
  proposition: if you're writing a _library_ `setup.py` is needed anyway to
  allow `pip` to install the library (and its dependencies). For an
  _application_, a `Pipfile` could be sufficient.

  - `Pipfile`: declares high-level dependencies (similar to `setup.py`). Here
    you declare *what you want*.

  - `Pipfile.lock`: a snapshot of all transitive dependencies resulting from
    resolving dependencies in the `Pipfile`.


## How to structure your project
Source: https://realpython.com/pipenv-guide/

If your code needs to be distributed as a package, you should put your minimum
requirements in `setup.py` instead of directly with `pipenv install`. Then use
the `pipenv install '-e .'` command to install your package as editable. This
gets all the requirements from `setup.py` into your environment. Then you can
use `pipenv lock` to get a reproducible environment. That is:

- keep a `setup.py`. `install_requires` should include whatever the package
  "minimally needs to run correctly."

- `Pipfile` represents the concrete requirements for your package. Pull the
  minimally required dependencies from `setup.py` by installing your package
  using Pipenv: `pipenv install '-e .'`

- That results in a line in your Pipfile that looks something like
  `"e1839a8" = {path = ".", editable = true}`.

- `Pipfile.lock`: for a reproducible environment generated from `pipenv lock`

If your code doesn't need to be distributed (personal script, desktop app) you
don't need a `setup.py` -- just use a `Pipfile`/`Pipfile.lock` combo.


## Releasing a package on PyPi

1. Get a PyPi account

2. Upgrade necessary tools, cut a release tag, use `setuptools` to produce an
   sdist and a bdist, and use `twine` to upload to PyPi (you will need your PyPi
   credentials).

        pip install -U twine wheel setuptools
        git tag vX.Y.Z && git push origin vX.Y.Z
        python setup.py sdist bdist_wheel
        twine check dist/*
        twine upload dist/*


# Pipenv
Make `pipenv` create `virtualenv`s in the project dir instead of under
`~/.local/share/virtualenvs/`.

    PIPENV_VENV_IN_PROJECT=true

Create a venv for python3. Creates an empty `Pipfile` if none exists.

    pipenv --three

Add dependency to Pipfile.

    pipenv install Jinja2
    # with specific version
    pipenv install requests==2.10

Add local project dir (as editable) to `Pipfile`. Adding project dir itself
("editable") to `PYTHONPATH` is useful during development. Also, for a pipenv
client of the package, this means that `pipenv install <project-dir>` will also
include what's specified in `setup.py` (if anything), such as `console_scripts`.

    pipenv install '-e .'

Enter sub-shell for the virtualenv.

    pipenv shell

# pyenv
Lets you switch betwen multiple versions of Python. It is typically installed
under `~/.pyenv`. Add `~/.pyenv/bin` to the `PATH` and make sure to add a call
to `source <(pyenv init -)` in your shell initialization (`~/.bashrc`).

    # show available (and selected python version)
    pyenv versions

    # install a new version
    pyenv install 3.8.5

    # use a Python version globally
    pyenv global 3.8.5
    # set both python3 and python2 globally
    pyenv global 3.7.0 2.7.15

    # set a directory-tree local version by writing a .python-version
    pyenv local 3.7.0

If you additionally install `pyenv-virtualenv` you can use `pyenv` to manage
virtual environments (note: to use python2, make sure you've installed
`virtualenv` for `pyenv global 2.7.10; pip install -U virtualenv`).


    # create a virtualenv with the currently set python version
    pyenv virtualenv 2.7.10 my-project-py2

    # list virtualenvs
    pyenv virtualenvs

    # activate virtualenv
    pyenv activate my-project-py2
    # deactivate
    pyenv deactivate

    # delete
    pyenv virtualenv-delete my-project-py2

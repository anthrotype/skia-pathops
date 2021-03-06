# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -z "$IS_OSX" ]; then
        export CFLAGS="-static-libstdc++"
        export CC=/usr/local/gcc-9.1.0/bin/gcc-9.1.0
        export CXX=/usr/local/gcc-9.1.0/bin/g++-9.1.0

        if [ -n "$PYENV_PYTHON_VERSION" ]; then
            echo "Installing Python: $PYENV_PYTHON_VERSION"
            bash ci/pyenv_install_python.sh
            export PATH="$HOME/.pyenv/versions/$PYENV_PYTHON_VERSION/bin":$PATH
            python --version
            pip --version
        fi
    fi
}

function run_tests {
    # The function is called from an empty temporary directory.
    cd ..

    # Get absolute path to the pre-compiled wheel
    wheelhouse=$(abspath wheelhouse)
    wheel=$(ls ${wheelhouse}/skia_pathops*.whl | head -n 1)
    if [ ! -e "${wheel}" ]; then
        echo "error: can't find wheel in ${wheelhouse} folder" 1>&2
        exit 1
    fi

    # select tox environment based on the current python version
    # E.g.: '2.7' -> 'py27'
    TOXENV="py${MB_PYTHON_VERSION//\./}"

    # Install pre-compiled wheel and run tests against it
    tox --installpkg "${wheel}" -e "${TOXENV}"

    # clean up after us, or else running tox later on outside the docker
    # container can lead to permission errors
    rm -rf .tox
}

# Makefile for uv-managed Python project
# Usage:
#   make install               # upgrade pip/setuptools and install project deps into current venv
#   make build                 # build sdist + wheel into dist/
#   make test-upload           # upload to TestPyPI (requires TWINE_* env vars)
#   make upload                # upload to PyPI (requires TWINE_* env vars)
#   make install-lib-from-test # install package from TestPyPI (deps from PyPI)
#   make install-lib           # install package from PyPI
#   make clean                 # remove build artifacts
#   make format                # format code using ruff

PACKAGE ?= epicpydevicelib
TESTPYPI := https://test.pypi.org/simple
PYPI     := https://pypi.org/simple

.PHONY: install build test-upload upload install-lib-from-test install-lib clean format

# install:
# 	uv pip install -U pip setuptools wheel
# 	uv pip install -U -e .

install:
	uv pip install -U pip setuptools wheel
	uv sync

build:
	uvx --from build pyproject-build --sdist --wheel

test-upload: build
	uvx twine upload --repository testpypi dist/*

upload: build
	uvx twine upload --repository pypi dist/*

install-lib-from-test:
	uv pip install --index-url $(TESTPYPI) --extra-index-url $(PYPI) $(PACKAGE)

install-lib:
	uv pip install $(PACKAGE)

clean:
	@echo "Removing build artifacts..."
	rm -rf build/ dist/ *.egg-info
	find . -type d -name "__pycache__" -exec rm -rf {} +

format:
	ruff check epicpydevicelib --fix
	ruff format epicpydevicelib
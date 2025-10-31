---
description: "Construct an isolated environment for a pytorch-based project using docker and uv."
allowed-tools:
  [
    "Bash(uv:*)",
    "Bash(make:*)",
    "Update(pyproject.toml)",
    "Update(Makefile)",
    "Update(Dockerfile)",
  ]
---

# Claude Command: Setup Torch Environment

## Usage

```
/setup-torch-env
```

## Process

1. Check requirements
2. Configure `pyproject.toml`
3. Configure `Dockerfile`
4. Configure `Makefile`
5. Validate

Refer to the sections below for detailed description of each step.

## Requirement Check

Read documentation files such as `README.md`, `INSTALLATION.md`, or `pyproject.toml` to identify the requirements.
The following fields should be specified:

- `cuda_version` (default 12.1)
- `ubuntu_version` (default: 22.04)
- `python_version` (default 3.11)
- `torch_version` (default: 2.5.1)
- `torchvision_version` (default: 0.20.1)

These fields are used in the subsequent sections.
If any requirement is not specified, use the default values.

## Configure `pyproject.toml`

### Initial Setup

If starting fresh: Generate `pyproject.toml` by running:

```bash
uv init --bare --python [python_version]
```

If `pyproject.toml` exists: Skip `uv init` and proceed to edit the existing file according to the requirements below.

### Add core dependencies

Add `torch` and `torchvision` to your project dependencies.
Configure the `PyTorch` custom index:

```toml
[project]
name = "project"
version = "0.1.0"
requires-python = ">=3.12.0"
dependencies = [
    "torch==[torch_version]",
    "torchvision==[torchvision_version]",
]

[tool.uv.sources]
torch = [
    { index = "pytorch"},
]
torchvision = [
    { index = "pytorch"},
]

[[tool.uv.index]]
name = "pytorch"
url = "https://download.pytorch.org/whl/cu121"
explicit = true
```

Important: Replace `[torch_version]`, `[torchvision_version]`, and the index URL according to your requirements (e.g., different `CUDA` versions use different URLs).

### Configure Build System (if needed)

If your project requires a build system, add the `setuptools` configuration.
First check for an existing `setup.py` or `pyproject.toml` to obtain the necessary configuration information, then add:

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[tool.setuptools]
packages = ["project"]

[tool.setuptools.package-data]
"project" = ["src/project"]
```

### Add Additional Dependencies

Add any other Python dependencies specified in the documentation files.
If a `requirements.txt` exists, you can import all dependencies at once:

```bash
uv add -r requirements.txt
```

Otherwise, add dependencies individually using `uv add [package-name]`.
If dependencies conflict, then adjust the versions of python or other packages.

### Finalize Configuration

Run the following command to generate `uv.lock`:

```bash
uv sync
```

## Configure `Dockerfile`

Generate a `Dockerfile` using the example below.
Replace the base image tag and `[python_version]` according to the requirements.

```Dockerfile
FROM nvidia/cuda:12.1-cudnn-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install UV
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Install required apt packages and clear cache afterwards.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata \
    git \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
ARG TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install the project into `/app`
WORKDIR /app

# Set env variables for uv
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Grant 777 permissions to all newly created files under /root and /app
RUN chmod -R 777 /root /app

# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    set -uex; \
    umask 0002; \
    uv sync --locked --no-install-project --no-dev --python [python_version]

# Then, add the rest of the project source code and install it
# Installing separately from its dependencies allows optimal layer caching
COPY . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    set -uex; \
    umask 0002; \
    uv sync --locked --no-dev --python [python_version]

```

Add the `.dockerignore` below to the project root.

```.dockerignore
/data
.git
.venv
```

## Configure `Makefile`

Generate a Makefile using the example below.
Replace [PROJECT_NAME] with project name.

```Makefile
PROJECT_NAME := [PROJECT_NAME]
IMAGE_NAME := seunguk/${PROJECT_NAME}

PROJECT_ROOT := /app
DATA_DIR := /app/data

SHM_SIZE := 256gb
GPU_IDS ?= 0

TIMEZONE ?= Asia/Seoul

build:
 docker build \
  --tag ${IMAGE_NAME}:latest \
  -f Dockerfile .

run: DOCKER_INTERACTIVE := -it
claude-run: DOCKER_INTERACTIVE :=

run claude-run:
 @mkdir -p ./data
 @docker run \
  ${DOCKER_INTERACTIVE} \
  --rm \
  --gpus all \
  --user $(shell id -u):$(shell id -g) \
  --shm-size ${SHM_SIZE} \
  --workdir=${PROJECT_ROOT} \
  --volume="./data:${DATA_DIR}" \
  -e PROJECT_ROOT=${PROJECT_ROOT} \
  -e DATA_DIR=${DATA_DIR} \
  -e HOME=/tmp \
  -e XDG_CACHE_HOME=${DATA_DIR}/cache \
  -e XDG_DATA_HOME=${DATA_DIR}/cache \
  -e TRITON_CACHE_DIR=${DATA_DIR}/cache/triton \
  -e CUDA_VISIBLE_DEVICES=${GPU_IDS} \
  ${IMAGE_NAME}:latest \
  uv run $(filter-out $@,$(MAKECMDGOALS))


.PHONY: run build

%:
 @:

```

## Validation

Run make build to build the Docker image.
Then, run the following command to verify that the image was built correctly:

```bash
make claude-run -- echo "hello-world"
```

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

Read documentation files such as `README.md` or `INSTALLATION.md` to identify the requirements.
The following fields should be specified:

- `cuda_version` (default 12.1)
- `ubuntu_version` (default: 22.04)
- `python_version` (default 3.11)
- `pytorch_version` (default: 2.5.1)

These fields are used in the subsequent sections.
If any requirement is not specified, use the default values.

## Configure `pyproject.toml`

Generate `pyproject.toml` by running `uv init --bare --python [python_version]`
Then add `torch` and `torchvision` to it. The index should be specified as follows:

```toml
[project]
name = "project"
version = "0.1.0"
requires-python = ">=3.12.0"
dependencies = [
    "torch==2.5.1",
    "torchvision==0.20.1",
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

Replace the dependency versions and the URL according to the requirements.
Then add any additional Python dependencies specified in the documentation files.
If a `requirements.txt` file exists, dependencies can be added using the following command:

```bash
uv add -r requirements.txt
```

Then run `uv sync` to generate `uv.lock` properly.
If you encounter any errors, try relaxing the constraints for dependencies or adjusting the versions.

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

# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev --python [python_version]

# Then, add the rest of the project source code and install it
# Installing separately from its dependencies allows optimal layer caching
COPY . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev --python [python_version]

RUN chmod -R 777 /root /app

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

run:
 @mkdir -p ./data
 @docker run \
  -it \
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

claude-run:
 @mkdir -p ./data
 @docker run \
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

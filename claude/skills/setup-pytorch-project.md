# Setup PyTorch Project Skill

Automatically set up a Docker-based development environment for PyTorch projects with `just` command runner.

## What This Skill Does

This skill creates a complete Docker-based development environment for PyTorch projects, including:

1. **Dockerfile** - PyTorch base image with CUDA support
2. **docker-compose.yml** - Container orchestration with GPU access
3. **justfile** - Command runner with common PyTorch workflows
4. **.dockerignore** - Optimized Docker build context
5. **Directory structure** - Standard directories for data, outputs, and cache

## When to Use This Skill

Use this skill when you need to:
- Set up a new PyTorch project with Docker
- Add Docker support to an existing PyTorch project
- Standardize development environment across team members
- Ensure reproducible environments with GPU support
- Simplify common PyTorch workflows (training, inference, evaluation)

## Prerequisites Detection

Before running, the skill checks for:
- Existing `requirements.txt`, `environment.yml`, or `setup.py`
- PyTorch-related dependencies in the project
- CUDA version requirements
- Python version

## Generated Files

### 1. Dockerfile

Creates a multi-stage Dockerfile with:
- PyTorch official base image with CUDA support
- Non-interactive build (ARG DEBIAN_FRONTEND=noninteractive)
- System dependencies for common ML libraries
- Python package installation from project files
- Optimized layer caching
- Non-root user setup (optional)

### 2. docker-compose.yml

Configures:
- GPU access via NVIDIA runtime
- Volume mounts for code and data
- Environment variables (CUDA, cache directories)
- Network settings
- Shared memory for DataLoader
- Port mappings for notebooks/web apps

### 3. justfile

Provides commands for:
- Building and managing containers
- Running training scripts
- Running inference/demo scripts
- Evaluation workflows
- Jupyter notebook server
- TensorBoard server
- GPU monitoring
- Package installation
- Cleanup operations

### 4. .dockerignore

Excludes:
- Python cache files
- Virtual environments
- Large data directories
- Model checkpoints
- IDE configurations
- Git files

## Configuration Options

The skill adapts based on project structure:

### Python Version
- Detects from `environment.yml`, `setup.py`, or `.python-version`
- Uses project-specified version

### CUDA Version
- Detects from existing dependencies
- Defaults to CUDA 11.8
- Supports CUDA 11.x and 12.x

### PyTorch Version
- Uses version from requirements if specified
- Defaults to latest stable PyTorch

### Package Manager
- Detects pip (requirements.txt)
- Detects conda (environment.yml)
- Detects setup.py with extras_require

### Cache Directory
- Default: `./data/cache`
- Maps to container via `XDG_CACHE_HOME`
- Configurable location

### Data Directory
- Default: `./data`
- Mounted as volume
- Configurable location

## Generated Just Commands

### Container Management
```bash
just build          # Build Docker image
just up             # Start container
just down           # Stop container
just shell          # Enter container shell
just restart        # Restart container
just logs           # View container logs
```

### Development Workflows
```bash
just train          # Run training script
just eval           # Run evaluation
just demo           # Run demo/inference
just test           # Run tests
```

### Tools
```bash
just jupyter        # Start Jupyter notebook server
just tensorboard    # Start TensorBoard
just gpu-check      # Check GPU availability
```

### Utilities
```bash
just install PKG    # Install additional package
just clean          # Remove containers and volumes
just clean-all      # Remove everything including images
```

## Project Structure Created

```
project/
├── Dockerfile
├── docker-compose.yml
├── justfile
├── .dockerignore
├── data/
│   ├── cache/      # Model cache
│   ├── raw/        # Raw datasets
│   └── processed/  # Processed datasets
├── outputs/        # Training outputs
├── logs/           # Training logs
├── checkpoints/    # Model checkpoints
└── notebooks/      # Jupyter notebooks
```

## Customization

After generation, you can customize:

### Dockerfile
- Add system dependencies
- Change base image
- Add build arguments
- Multi-stage builds

### docker-compose.yml
- GPU selection (specific devices)
- Port mappings
- Volume mounts
- Environment variables
- Resource limits

### justfile
- Add project-specific commands
- Modify default parameters
- Add new workflows
- Custom cleanup tasks

## Example Usage

### Setting Up a New Project

1. Navigate to your PyTorch project directory
2. Invoke the skill: `/setup-pytorch-project` or use the Skill tool
3. Review generated files
4. Run `just setup` to build and start

### Setting Up Existing Project

The skill detects existing configuration and adapts:
- Reads dependencies from `requirements.txt` or `environment.yml`
- Detects Python/CUDA versions
- Preserves existing directory structure
- Adds missing components

## Advanced Features

### Multi-GPU Support
```yaml
# docker-compose.yml
environment:
  - CUDA_VISIBLE_DEVICES=0,1,2,3
```

### Custom Base Image
```dockerfile
# Dockerfile
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel
```

### Development vs Production

Generate separate configurations:
- `docker-compose.dev.yml` - Development with code mounting
- `docker-compose.prod.yml` - Production with code copied

### Experiment Tracking

Add integrations for:
- Weights & Biases
- MLflow
- TensorBoard
- Neptune.ai

## Best Practices

The skill follows PyTorch best practices:

1. **Reproducibility**
   - Pin package versions
   - Set random seeds
   - Document CUDA/cuDNN versions

2. **Performance**
   - Shared memory for DataLoader
   - Persistent volumes for data
   - Layer caching in Dockerfile

3. **Security**
   - Non-root user in container
   - No secrets in images
   - Minimal base image

4. **Development**
   - Code mounted as volume
   - Hot reload for development
   - Interactive debugging support

## Troubleshooting

Common issues the skill handles:

### GPU Access
- Verifies NVIDIA runtime
- Sets correct environment variables
- Provides GPU check command

### Dependencies
- Detects conflicting versions
- Handles git dependencies
- Supports extras_require

### Permissions
- Sets correct file ownership
- Handles volume permissions
- User/group mapping

## Integration with CI/CD

Generated files support CI/CD:

```yaml
# .github/workflows/train.yml
- name: Build Docker image
  run: just build

- name: Run training
  run: just train
```

## Notes

- The skill preserves existing Docker files (asks before overwriting)
- Generated files are templates - customize as needed
- Follows Docker and PyTorch best practices
- Compatible with most PyTorch projects (classification, detection, segmentation, etc.)
- Supports both training and inference workflows

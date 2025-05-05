# Docker Image for Python and TensorFlow with CUDA Support

This repository contains a Dockerfile to create a Docker image with Ubuntu 20.04, Miniconda, Python 3.10, CUDA toolkit, cuDNN, TensorFlow, and additional Python packages.

## Prerequisites

- Docker installed on your machine
- Docker Compose (optional, if you plan to use it)

## Building the Docker Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t my-tensorflow-image .
```

This command will create a Docker image named `my-tensorflow-image`.

## Running the Docker Container 

To run a container from the built image, use the following command:

```sh
docker run -it --rm my-tensorflow-image
```

This command will start a container in interactive mode and remove it after you exit.

## Testing the Docker Image

To test if TensorFlow is installed correctly with CUDA support, you can run the following commands inside the running container:

```sh
python -c "import tensorflow as tf; print(tf.__version__)"
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
python -c "from tensorflow.python.client import device_lib; device_lib.list_local_devices()"
```

The first command will print the TensorFlow version, and the second command will list the available GPUs.

## Additional Information

- The environment directory contains a requirements.txt file with additional Python packages to be installed.
- The Dockerfile sets up the necessary environment variables and installs the required dependencies.

## Maintainer

Shrey Pareek


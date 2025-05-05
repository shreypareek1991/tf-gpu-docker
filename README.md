
# Docker Image for CUDA and TensorFlow

## Overview

This repository contains a Dockerfile that sets up an Ubuntu-based environment with CUDA and TensorFlow. The Docker image includes Miniconda for package management and Python 3.10.

## Prerequisites

- Docker installed on your machine
- Internet connection to download dependencies

## Building the Docker Image

To build the Docker image, follow these steps:

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/yourusername/yourrepository.git
    cd yourrepository
    ```

2. Build the Docker image using the Dockerfile:
    ```sh
    docker build -t cuda-tensorflow-image .
    ```

    This command will create a Docker image named `cuda-tensorflow-image` using the Dockerfile in the current directory.

## Running the Docker Container

To run a container from the built Docker image, use the following command:

```sh
docker run -it --rm cuda-tensorflow-image

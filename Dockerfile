# Use the official Ubuntu base image version 20.04
FROM ubuntu:20.04

# Set the maintainer label for the Docker image
LABEL maintainer="Shrey Pareek"

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Define an argument for Miniconda URL
ARG MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
ARG TF_VERSION=2.13

# Update the package list, install wget, download and install Miniconda, and clean up
RUN apt-get update -y \
    && apt-get install -y wget \
    && wget $MINICONDA_URL -O ~/miniconda.sh --no-check-certificate \
    && /bin/bash ~/miniconda.sh -b -p $CONDA_DIR \
    && rm -rf ~/miniconda.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Add conda to the PATH and activate the base environment by default
RUN echo "source activate base" > ~/.bashrc

# Install Python 3.10, pip, CUDA toolkit, cuDNN, TensorFlow, and additional Python packages
RUN conda install -y python=3.10 pip \
    && pip install --upgrade pip setuptools \
    && conda install -c conda-forge cudatoolkit=11.8 cudnn=8.9 -y \
    && mkdir -p $CONDA_PREFIX/etc/conda/activate.d \
    && mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d \
    && printf "export OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}\nexport LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CONDA_PREFIX}/lib/\n" > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && printf "export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}\nunset OLD_LD_LIBRARY_PATH\n" > $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh \
    && . $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && conda clean -a \
    && pip install "tensorflow[and-cuda]==${TF_VERSION}" \
    && pip install --no-cache-dir -r /environment/requirements.txt

# Copy the environment directory from the host to the container
COPY environment /environment

# Copy the current directory contents into the container
COPY . .

# Set the default command to run when starting the container
CMD ["/bin/bash"]

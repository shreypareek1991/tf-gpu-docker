# Use the official Ubuntu base image version 20.04
FROM ubuntu:20.04

# Copy the environment directory from the host to the container
COPY environment /environment

# Set the maintainer label for the Docker image
LABEL maintainer="Shrey Pareek"

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Define the directory where Miniconda will be installed
ENV CONDA_DIR=/opt/conda

# Add the Miniconda bin directory to the PATH environment variable
ENV PATH=$CONDA_DIR/bin:$PATH

# Update the package list and install wget for downloading files
RUN apt-get update -y \
    && apt-get install wget -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh --no-check-certificate \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm -rf ~/miniconda.sh

# Add conda to the PATH and activate the base environment by default
RUN echo "source activate base" > ~/.bashrc
ENV PATH $CONDA_DIR/envs/env/bin:$PATH

# Install Python 3.10 and pip using conda, then upgrade pip and setuptools
RUN conda install -y python=3.10 pip \
    && pip install --upgrade pip setuptools

# Install CUDA toolkit and cuDNN using conda-forge channel
RUN conda install -c conda-forge cudatoolkit=11.8 cudnn=8.9 -y \
    && mkdir -p $CONDA_PREFIX/etc/conda/activate.d \
    && mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d \
    && printf "export OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}\nexport LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CONDA_PREFIX}/lib/\n" > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && printf "export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}\nunset OLD_LD_LIBRARY_PATH\n" > $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh \
    && . $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && conda clean -a

# Define an argument for TensorFlow version
ARG TF_VERSION=2.13

# Install TensorFlow with CUDA support using pip
RUN echo "TensorFlow ${TF_VERSION} will be installed..."
RUN pip install "tensorflow[and-cuda]==${TF_VERSION}"

# Install additional Python packages specified in the requirements.txt file
RUN pip install --no-cache-dir -r /environment/requirements.txt

# Copy the current directory contents into the container
COPY . .

# Set the default command to run when starting the container
CMD ["/bin/bash"]

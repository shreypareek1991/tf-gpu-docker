FROM ubuntu:20.04

COPY environment /environment

LABEL maintainer="Shrey Pareek"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Download wget so that we can download miniconda installer
RUN apt-get update -y \
    && apt-get install wget -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh --no-check-certificate \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm -rf ~/miniconda.sh

# Add conda to path
RUN echo "source activate base" > ~/.bashrc
ENV PATH $CONDA_DIR/envs/env/bin:$PATH

# Install Python and pip
RUN conda install -y python=3.10 pip \
    && pip install --upgrade pip setuptools

# NVIDIA Install
RUN conda install -c conda-forge cudatoolkit=11.8 cudnn=8.9 -y \
    && mkdir -p $CONDA_PREFIX/etc/conda/activate.d \
    && mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d \
    && printf "export OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}\nexport LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CONDA_PREFIX}/lib/\n" > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && printf "export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}\nunset OLD_LD_LIBRARY_PATH\n" > $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh \
    && . $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh \
    && conda clean -a

ARG TF_VERSION=2.13

RUN echo "TensorFlow ${TF_VERSION} will be installed..."
RUN pip install "tensorflow[and-cuda]==${TF_VERSION}"

RUN pip install --no-cache-dir -r /environment/requirements.txt

COPY . .

CMD ["/bin/bash"]

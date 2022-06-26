FROM ubuntu:latest

# update
RUN apt-get -y update && apt-get install -y \
sudo \
wget \
vim

#install anaconda3
WORKDIR /opt
# download anaconda package and install anaconda
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh && \
sh /opt/Anaconda3-2022.05-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2022.05-Linux-x86_64.sh
# set path
ENV PATH /opt/anaconda3/bin:$PATH

COPY ./opt-from-host/current /opt

# update pip and conda
RUN pip install --upgrade pip && \
sudo apt install nodejs npm -y && \
sudo npm install n -g && \
sudo n latest && \
conda uninstall jupyterlab -y && \
conda install jupyterlab=3.0.14 -y && \
bash /opt/current && \
pip install "jupyterlab-kite>=2.0.2" && \
conda install numpy pandas matplotlib -y

WORKDIR /
RUN mkdir /work
WORKDIR /work

# execute jupyterlab as a default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]
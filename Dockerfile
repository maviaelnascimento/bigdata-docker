# Start from a core stack version
FROM jupyter/all-spark-notebook

USER root

COPY requirements.txt /tmp/

RUN apt-get update && apt-get install -f -y g++ libpcre3 libpcre3-dev
RUN cd /home/ && wget -O swig.tar.gz http://prdownloads.sourceforge.net/swig/swig-4.0.0.tar.gz
RUN chmod 777 /home/swig.tar.gz
RUN tar -xzvf /home/swig.tar.gz
RUN tar -C /home/ -xzvf /home/swig.tar.gz
RUN cd /home/swig-4.0.0 && ./configure --prefix=/home/$NB_USER/library/swigtool && make && make install

ENV SWIG_PATH=/home/$NB_USER/library/swigtool/bin
ENV PATH=$SWIG_PATH:$PATH
RUN echo 'export SWIG_PATH=/home/$NB_USER/library/swigtool/bin' >> /home/$NB_USER/.bash_profile
RUN echo 'export PATH=$SWIG_PATH:$PATH' >> /home/$NB_USER/.bash_profile
RUN echo $SWIG_PATH

RUN cd /usr/lib/x86_64-linux-gnu && ln -s libpcre.so libpcre.so.1

RUN apt-get install -f -y libpulse-dev libasound2-dev

USER $NB_UID

RUN pip install --upgrade --force-reinstall pip==9.0.3
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
RUN pip install --upgrade pip
FROM ubuntu:focal

# Get latest packages
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    default-jdk \
    git \
    gpg-agent \
    graphviz \
    make \
    nano \
    python3-pip \
    software-properties-common \
    sudo \
    unzip \
    vim \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN useradd stscript \
  && echo "stscript:stscript" | chpasswd \
  && adduser stscript sudo \
  && mkdir /home/stscript \
  && chown stscript:stscript /home/stscript

RUN mkdir /home/stscript/bin

##############################################################################
# Helper scripts
##############################################################################

COPY --chown=stscript:stscript \
  scripts /home/stscript/scripts/

RUN chmod +x /home/stscript/scripts/*

##############################################################################
# Scribble-Java
##############################################################################

COPY --chown=stscript:stscript \
  scribble-java /home/stscript/scribble-java/

COPY --chown=stscript:stscript \
  scribble.patch /home/stscript/scribble-java/

RUN cd /home/stscript/scribble-java \
  && patch -p1 < scribble.patch \
  && rm scribble.patch \
  && ./mvnw -Dlicense.skip install \
  && cd scribble-dist/target \
  && unzip scribble-dist-0.4.4-SNAPSHOT.zip \
  && chmod +x scribblec.sh \
  && cp -r lib scribblec.sh /home/stscript/bin

##############################################################################
# Protocols
##############################################################################

COPY --chown=stscript:stscript \
  protocols /home/stscript/protocols/

##############################################################################
# Codegen
##############################################################################

COPY --chown=stscript:stscript \
  codegen /home/stscript/codegen/

# Setup Python
RUN add-apt-repository -y ppa:deadsnakes/ppa \
  && apt-get install python3.8 \
  && echo python3.8 --version

RUN python3.8 -m pip install -r /home/stscript/codegen/requirements.txt

# Setup NodeJS
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh \
  && bash ./nodesource_setup.sh \
  && apt-get -y install nodejs

RUN npm i -g \
  npm typescript typescript-formatter concurrently serve

##############################################################################
# Web sandbox
##############################################################################

COPY --chown=stscript:stscript \
  web-sandbox /home/stscript/web-sandbox

# Prepare web-sandbox
RUN cd /home/stscript/web-sandbox \
  && cd node \
  && npm i \
  && cd ../browser \
  && npm i \
  && cd ../../

##############################################################################
# Case studies
##############################################################################

COPY --chown=stscript:stscript \
  case-studies /home/stscript/case-studies/

# Prepare case studies
RUN cd /home/stscript/case-studies \
  && for app in $(ls -d */); do \
         cd $app \
      && npm i \
      && cd client \
      && npm i \
      && cd ../.. \
      && pwd; \
  done

##############################################################################
# Perf benchmarks
##############################################################################

# Setup perf-benchmarks
COPY --chown=stscript:stscript \
  perf-benchmarks /home/stscript/perf-benchmarks/

RUN find /home/stscript/perf-benchmarks -name "*.sh" -exec chmod +x {} \;

RUN cd /home/stscript/perf-benchmarks \
  && python3.8 -m pip install -r requirements.txt \
  && cd simple_pingpong \
    && npm i \
    && npm run build-all \
  && cd ../complex_pingpong \
    && npm i \
    && npm run build-all

##############################################################################
# Workspace setup
##############################################################################

RUN chown -R stscript:stscript /home/stscript

RUN echo 'alias python=python3.8' \
    >> /home/stscript/.bashrc

RUN echo '[ ! -z "$TERM" -a -r /etc/welcome ] && cat /etc/welcome' \
    >> /etc/bash.bashrc \
    ; echo "\
To run the code generator, you can do\n\
  $ codegen --help\n\
\n\
To run a case study application, for example Battleships, you can do\n\
  $ cd ~/case-studies/Battleships\n\
  $ npm run build\n\
  $ npm start\n\
and visit http://localhost:8080\n\
\n\
To run the performance benchmarks, you can do\n\
  $ cd ~/perf-benchmarks\n\
  $ ./run_benchmark.sh\n\
\n\
To visualise the benchmarks, you can do\n\
  $ cd ~/perf-benchmarks\n\
  $ jupyter notebook\n\
then click on the \"localhost\" link on the terminal output,\n\
open the \"STScript Benchmark Visualisation\" notebook, and run all cells\n\
"\
    > /etc/welcome

USER stscript

WORKDIR /home/stscript

ENV PATH="/home/stscript/bin:/home/stscript/scripts:$PATH"
EXPOSE 5000 8080 8888

FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-devel

# ----------------------------------------------------------------------------
# -- install apt
# ----------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y \
    ant \
    ca-certificates-java \
    openjdk-8-jdk \
    unzip \
    wget && \
    apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN update-ca-certificates -f && export JAVA_HOME


# ----------------------------------------------------------------------------
# -- download pretrained imagenet weights for resnet-101
# ----------------------------------------------------------------------------

RUN mkdir -p /workspace/data/imagenet_weights && \
    cd /workspace/data/imagenet_weights && \
    wget --quiet https://www.dropbox.com/sh/67fc8n6ddo3qp47/AAACkO4QntI0RPvYic5voWHFa/resnet101.pth


# ----------------------------------------------------------------------------
# -- download corenlp jar
# ----------------------------------------------------------------------------

RUN mkdir -p /workspace/prepro && \
    cd /workspace/prepro && \
    wget --quiet https://nlp.stanford.edu/software/stanford-corenlp-full-2017-06-09.zip && \
    unzip stanford-corenlp-full-2017-06-09.zip && \
    rm stanford-corenlp-full-2017-06-09.zip

COPY ./tools/coco-caption/get_stanford_models.sh /workspace/tools/coco-caption/get_stanford_models.sh
RUN cd /workspace/tools/coco-caption && \
    mkdir -p pycocoevalcap/spice/lib && \
    sh get_stanford_models.sh


# ----------------------------------------------------------------------------
# -- download pretrained model
# ----------------------------------------------------------------------------

RUN mkdir -p /workspace/save && \
    cd /workspace/save && \
    wget --quiet https://www.dropbox.com/s/6buajkxm9oed1jp/coco_nbt_1024.tar.gz && \
    tar -xzvf coco_nbt_1024.tar.gz && \
    rm coco_nbt_1024.tar.gz


# ----------------------------------------------------------------------------
# -- install pip dependencies
# ----------------------------------------------------------------------------

RUN pip install Cython && pip install h5py \
    matplotlib \
    nltk \
    numpy \
    pycocotools \
    scikit-image \
    stanfordcorenlp \
    tensorflow \
    torchtext \
    pdbpp \
    jupyter \
    tqdm && python -c "import nltk; nltk.download('punkt')"


VOLUME ["/workspace/save", "/workspace/neuralbabytalk", "/opt/conda"]

WORKDIR /workspace/neuralbabytalk

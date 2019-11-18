FROM centos

WORKDIR /usr/src/app

RUN yum update -y
RUN yum upgrade

# Install Python 3.6
#ENV PYTHON_VERSION "3.6.0"
#ENV POSTGRES_REPO "https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm"
#
#RUN yum install -y ${POSTGRES_REPO} \
#    && yum install -y gcc make zlib-dev openssl-devel sqlite-devel bzip2-devel postgresql96-devel \
#    && yum clean all
#
#RUN curl -SLO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
#    && tar xvf Python-${PYTHON_VERSION}.tgz \
#    && cd Python-${PYTHON_VERSION} \
#    && ./configure --prefix=/usr/local \
#    && make \
#    && make altinstall \
#    && cd / \
#    && rm -rf Python-${PYTHON_VERSION}*
#
#ENV PATH "/usr/local/bin:/usr/pgsql-9.6/bin:${PATH}"

RUN yum -y install epel-release && yum clean all
RUN yum -y install python-pip && yum clean all


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


ENV JAVA_HOME /usr/lib/jvm/java-openjdk
RUN yum update -y; \
    yum install -y java-1.8.0-openjdk-devel wget unzip curl vim python-setuptools sudo; \
    easy_install supervisor; \
    yum clean all

COPY tableau-tabcmd-2019-2-2.noarch.rpm .
RUN yum install -y ./tableau-tabcmd-2019-2-2.noarch.rpm
RUN /opt/tableau/tabcmd/bin/tabcmd --accepteula > /dev/null

ENV PATH="/opt/tableau/tabcmd/bin:${PATH}"

COPY . .
#CMD [ "bash" ]
CMD [ "python", "./hyperpublisher.py" ]
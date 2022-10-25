FROM mcr.microsoft.com/azure-functions/python:4.4.1-python3.10

# Setup azure required env variables
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true


# Install necessary libraries
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -yqq install gcc && \
    apt-get -yqq install libffi-dev 

# Fix CVEs
RUN wget -O libc6.deb https://snapshot.debian.org/archive/debian/20220319T215212Z/pool/main/g/glibc/libc6_2.31-13%2Bdeb11u3_amd64.deb && \
    dpkg -i libc6.deb

RUN wget -O libcurl4.deb http://ftp.de.debian.org/debian/pool/main/c/curl/libcurl4_7.74.0-1.3+deb11u3_amd64.deb && \
    dpkg -i libcurl4.deb

RUN wget -O curl.deb 	http://ftp.de.debian.org/debian/pool/main/c/curl/curl_7.74.0-1.3+deb11u3_amd64.deb && \
    dpkg -i curl.deb

RUN wget -O logsave.deb http://ftp.debian.org/debian/pool/main/e/e2fsprogs/logsave_1.46.5-2~bpo11+2_amd64.deb && \
    dpkg -i logsave.deb

RUN wget -O libgd2.deb http://ftp.debian.org/debian/pool/main/libg/libgd2/libgd3_2.2.5-5.2_amd64.deb && \
    dpkg -i libgd2.deb

RUN apt-get update && apt --fix-broken install && \
    apt-get -yqq purge mariadb-common

# Install python packages and put everything in the running directory
COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /home/site/wwwroot

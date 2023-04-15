FROM ubuntu:latest
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN=2OPZWFBP1BElcN5va5B4nR7yURI_3uBpA2f97FHFf2UtoF2vY
RUN apt install ssh wget unzip -y > /dev/null 2>&1
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/kaal.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/kaal.sh
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/kaal.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:kaal|chpasswd
RUN service ssh start
RUN chmod 755 /kaal.sh
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /kaal.sh

RUN apt update && apt upgrade -y
RUN apt install git -y
COPY requirements.txt /requirements.txt
RUN cd /
RUN pip3 install -U pip && pip3 install -U -r requirements.txt

COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]

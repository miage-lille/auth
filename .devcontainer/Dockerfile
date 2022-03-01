FROM  node:17-buster

RUN apt-get update && apt-get install -qy locales \
  && echo "en_US ISO-8859-1" >> /etc/locale.gen && locale-gen

# #Locales
ENV LANGUAGE=en_US.ISO-8859-1
ENV LANG=en_US.ISO-8859-1
ENV LC_ALL=en_US.ISO-8859-1

RUN npm i -g esy
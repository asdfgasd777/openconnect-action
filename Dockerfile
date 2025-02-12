FROM ubuntu:latest

# Actualizamos la lista de paquetes e instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
  git \
  autotools-dev \
  automake \
  libtool \
  pkg-config \
  m4 \
  gettext \
  openssl \
  libssl-dev \
  libxml2-dev \
  vpnc-scripts \
  build-essential \
  zlib1g-dev \
  sudo

# Instalamos OpenConnect V9.01 desde el repositorio oficial 
# Configurar el directorio de trabajo
WORKDIR /openconnect
RUN git clone https://gitlab.com/openconnect/openconnect.git . && \
    git checkout v9.01
RUN ./autogen.sh
RUN ./version.sh version.c
RUN ./configure
RUN make -j$(nproc)
RUN make install && \
    ldconfig

# Agregamos el script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /

# Establecer el script de entrada
ENTRYPOINT ["/entrypoint.sh"]
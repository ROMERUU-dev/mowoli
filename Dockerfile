# Utilizamos una versión más reciente de Ruby con una base más estable de Debian
FROM ruby:2.7.0-buster

# Instalamos las dependencias necesarias para Node.js
RUN apt-get update \
  && apt-get -y --no-install-recommends install nodejs \
  && rm -rf /var/lib/apt/lists/*

# Instalamos la versión requerida de bundler (1.11.2)
RUN gem install bundler:1.11.2

WORKDIR /opt/mowoli
COPY Gemfile Gemfile.lock ./

# Instalamos las gemas de Ruby utilizando Bundler
RUN bundle install

# Copiamos el resto de los archivos de la aplicación
COPY . .

# Creamos los directorios necesarios para MWL, DB y HL7
RUN mkdir -p var/mwl var/db var/hl7

# Volúmenes para persistencia de datos
VOLUME /opt/mowoli/var/mwl /opt/mowoli/var/db /opt/mowoli/var/hl7

# Directorio para la Worklist (MWL)
ENV MWL_DIR="/opt/mowoli/var/mwl"

# Directorio para archivos HL7
ENV HL7_EXPORT_DIR="/opt/mowoli/var/hl7"

# Nombre del hospital o clínica (máx. 64 caracteres)
ENV SCHEDULED_PERFORMING_PHYSICIANS_NAME="Simpson^Bart"

# Identificador de la Autoridad Emisora del ID del Paciente
ENV ISSUER_OF_PATIENT_ID="MOWOLI"

# Configuración del entorno de Rails
ENV RAILS_ENV=development

# Exponemos el puerto 3000 para la aplicación
EXPOSE 3000

# Comando para iniciar el servidor Puma con configuración en config/puma.rb
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]

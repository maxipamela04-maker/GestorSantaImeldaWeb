# ---------- Etapa 1: compilar el proyecto con Maven ----------
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY prototipo/pom.xml prototipo/pom.xml
COPY prototipo/src prototipo/src
RUN mvn -f prototipo/pom.xml clean package -DskipTests

# ---------- Etapa 2: servidor Tomcat 9 ----------
FROM tomcat:9.0-jdk11-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/prototipo/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Limitar memoria (el plan gratis tiene 512 MB)
ENV CATALINA_OPTS="-Xms64m -Xmx320m"

# Render asigna el puerto en la variable PORT; Tomcat debe escuchar en él
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]

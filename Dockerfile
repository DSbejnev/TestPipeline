FROM maven:3.8.3-openjdk-17 as build

COPY pom.xml /build/
COPY src /build/src/
WORKDIR /build/

RUN mvn package -DskipTests && mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:17
ARG DEPENDENCY=/build/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","com.example.demo.DemoApplication"]
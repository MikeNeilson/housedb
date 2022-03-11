FROM alpine:3.15 as builder

RUN apk update && apk upgrade 
RUN apk add cmake openssl-dev openssl-libs-static libpq-dev postgresql-dev gcc g++ make git boost-dev zlib-static libpq postgresql-common binutils-dev build-base
ADD . /src/
RUN mkdir -p /src/build
WORKDIR /src/build
# NOTE: perhaps actually figure out *WHY* these aren't getting found
RUN cmake -DCMAKE_CXX_STANDARD_LIBRARIES="-lpgcommon -lpgport -lpgtypes -lopcodes -lssl -lcrypto" \
          -DBUILD_STATIC_API=ON \
          -DCMAKE_EXE_LINKER_FLAGS="-static -static-libgcc -static-libstdc++" .. \
    && make && strip src/api/api

FROM scratch

COPY --from=builder /src/build/src/api/api /api
COPY --from=builder /src/passwd /etc/passwd
USER api
#HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/api", "-c" ]
ENTRYPOINT [ "/api"]
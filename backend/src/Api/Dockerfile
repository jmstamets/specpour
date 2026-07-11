# Build context is backend/ (see docker-compose.yml). Multi-stage: SDK to build/publish,
# ASP.NET runtime image to run — keeps the final image free of the full SDK.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY . .
RUN dotnet publish src/Api/SpecPour.Api.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Npgsql probes for GSSAPI/Kerberos support at connect time; without it every query
# logs a harmless-but-noisy "Cannot load library libgssapi_krb5.so.2" to stderr (the
# app still works — auth falls back to password). Installing it silences that.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "SpecPour.Api.dll"]

# Build context is backend/ (see docker-compose.yml), matching Api/Dockerfile's pattern.
# Deploy-time migration job (constitution Principle III): runs once, applies every
# schema/module migration in order, then exits — never runs inside the Api container
# and never runs at Api app start.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY . .
RUN dotnet publish src/Tools/MigrationRunner/SpecPour.Tools.MigrationRunner.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# See Api/Dockerfile for why: silences Npgsql's harmless GSSAPI/Kerberos probe warning.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "SpecPour.Tools.MigrationRunner.dll"]

# Build context is backend/ (see docker-compose.yml), matching Api/Dockerfile and
# MigrationRunner/Dockerfile's pattern.
# T181: one-shot deterministic-content seeding job — imports the curated launch
# content (recipes/ingredients/equipment/glossary/concepts, backend/src/Tools/
# Seeder/Content/*.json) so CI's frontend-web-browser-tests docker stack has real
# catalog data to assert against, instead of an empty database. Idempotent
# (CuratedContentImporter's deterministic IDs make re-runs a no-op), so it's also
# safe to run against a dev stack that already has data.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY . .
RUN dotnet publish src/Tools/Seeder/SpecPour.Tools.Seeder.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# See Api/Dockerfile for why: silences Npgsql's harmless GSSAPI/Kerberos probe warning.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "SpecPour.Tools.Seeder.dll"]

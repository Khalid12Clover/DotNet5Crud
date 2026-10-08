```dockerfile
# =========================
# Runtime image
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

WORKDIR /app

EXPOSE 8080

# =========================
# Build image
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy project file first for better Docker layer caching
COPY ["DotNet5Crud.csproj", "./"]

# Restore dependencies
RUN dotnet restore "DotNet5Crud.csproj"

# Copy application source
COPY . .

# Build application
RUN dotnet build "DotNet5Crud.csproj" \
    -c Release \
    -o /app/build \
    --no-restore

# =========================
# Publish
# =========================
FROM build AS publish

RUN dotnet publish "DotNet5Crud.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

# =========================
# Final image
# =========================
FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "DotNet5Crud.dll"]
```


# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["DotNet5Crud.csproj", "./"]
RUN dotnet restore "DotNet5Crud.csproj"

COPY . .
RUN dotnet build "DotNet5Crud.csproj" -c Release -o /app/build --no-restore

# Publish application
FROM build AS publish
RUN dotnet publish "DotNet5Crud.csproj" -c Release -o /app/publish --no-restore

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNet5Crud.dll"]

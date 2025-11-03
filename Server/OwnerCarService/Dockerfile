# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY OwnerCarService.csproj ./
RUN dotnet restore

COPY . ./

# build and publish app
RUN dotnet publish -c Release -o /app/publish

# Stage 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

#copy from build stage
COPY --from=build /app/publish .

#environment variables
ENV ASPNETCORE_URLS=http://+:8081
ENV ASPNETCORE_ENVIRONMENT=Development

# Expose internal port
EXPOSE 8081

ENTRYPOINT [ "dotnet","OwnerCarService.dll" ]
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY webApiForContainer/*.csproj ./webApiForContainer/
COPY webApiForContainer/*.config ./webApiForContainer/
RUN nuget restore

# copy everything else and build app
COPY webApiForContainer/. ./webApiForContainer/
WORKDIR /app/webApiForContainer
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/webApiForContainer/. ./
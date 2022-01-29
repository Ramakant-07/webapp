FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# FROM microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /app

COPY WebApp/*.csproj ./
COPY . ./
RUN dotnet restore 

FROM build-env AS publish
RUN dotnet publish -c Release -o /app

# Build runtime image
#FROM microsoft/dotnet:6.0-aspnetcore-runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApp.dll", "--server.urls", "http://*:80"]

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["Assignment-Cloud/Assignment-Cloud.csproj", "Assignment-Cloud/"]
RUN dotnet restore "Assignment-Cloud/Assignment-Cloud.csproj"
COPY . .
WORKDIR "/src/Assignment-Cloud"
RUN dotnet build "Assignment-Cloud.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Assignment-Cloud.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Assignment-Cloud.dll"]

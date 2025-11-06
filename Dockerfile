# 使用官方 .NET 8 SDK 建置專案
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製專案檔並還原 NuGet 套件
COPY *.csproj ./
RUN dotnet restore

# 複製全部程式碼並建置發行版本
COPY . ./
RUN dotnet publish -c Release -o /app

# 使用 ASP.NET Runtime 來執行
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app .

# Render 預設會將 PORT 環境變數傳入（ex: 10000）
ENV ASPNETCORE_URLS=http://0.0.0.0:10000

ENTRYPOINT ["dotnet", "WeddingGame.dll"]

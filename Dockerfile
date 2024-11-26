# Use uma imagem base oficial do Python
FROM python:3.10-slim

# Atualize o sistema e instale dependências essenciais
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Adicione o repositório do Google Chrome e instale o Google Chrome estável
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Configure variáveis de ambiente para evitar mensagens interativas
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Configure variáveis de ambiente para o Google Chrome e o ChromeDriver
ENV CHROME_BIN=/usr/bin/google-chrome
ENV CHROME_DRIVER=/usr/bin/chromedriver

# Crie o diretório de trabalho
WORKDIR /app

# Copie os arquivos necessários para o contêiner
COPY . /app

# Atualize o pip para evitar problemas com versões antigas
RUN pip install --upgrade pip

# Instale as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponha a porta necessária (caso use servidor HTTP)
EXPOSE 5000

# Comando para executar o script principal
CMD ["python", "youtube_viewer.py"]
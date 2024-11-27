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
    libxrender1 \
    libxext6 \
    libxrandr2 \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    x11-utils \
    libx11-xcb1 \
    libxcb-glx0 \
    libxrender1 \
    libxext6 \
    libxrandr2 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    libnss3 \
    fonts-liberation \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:0

# Adicione o repositório do Google Chrome e instale o Google Chrome estável
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    wget -q "https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/bin/ && \
    rm /tmp/chromedriver.zip && \
    chmod +x /usr/bin/chromedriver

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

# Garanta que o script de inicialização seja executável
RUN chmod +x /app/start.sh

# Atualize o pip para evitar problemas com versões antigas
RUN pip install --upgrade pip

# Instale as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponha a porta necessária (caso use servidor HTTP)
EXPOSE 5000

# Substituir o comando principal por um script de inicialização
CMD ["bash", "/app/start.sh"]
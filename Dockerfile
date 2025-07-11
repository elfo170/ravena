# Use Node.js 18 Alpine para imagem menor
FROM node:18-alpine

# Instala dependências do sistema necessárias para puppeteer e outras libs
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    imagemagick \
    python3 \
    make \
    g++ \
    && rm -rf /var/cache/apk/*

# Define variáveis de ambiente para o Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Cria diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json (se existir)
COPY package*.json ./

# Instala dependências
RUN npm install --only=production

# Copia o código fonte
COPY . .

# Cria diretórios necessários
RUN mkdir -p data logs .wwebjs_auth

# Define permissões
RUN chown -R node:node /app
USER node

# Expõe porta se necessário (para API ou webhooks)
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
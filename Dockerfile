FROM node:18-bullseye-slim

# PuppeteerによるChromiumダウンロードを無効化し、システムのChromiumを使用
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 必要パッケージのインストール（Chromium本体と最低限の依存ライブラリ・フォント類）
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium chromium-sandbox \
    libxss1 libxtst6 libgconf-2-4 \
    fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst \
    dumb-init \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ設定
WORKDIR /app

# 依存関係インストール
COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile
RUN yarn install

COPY send-test.ts ./

# アプリケーションコードのコピー
COPY . .

# プロセス管理のためのinitを導入
ENTRYPOINT ["dumb-init", "--"]

# アプリ起動
CMD ["yarn", "start"]

# Dockerビルドと実行を簡略化するMakefile例

# イメージ名とタグ
IMAGE_NAME = twins-notification
IMAGE_TAG = arm64

# デフォルトターゲット: ビルド
build:
	@echo "Building Docker image for $(IMAGE_NAME)..."
	docker build --platform linux/arm64 -t $(IMAGE_NAME):$(IMAGE_TAG) .

# マルチアーキテクチャビルド例（必要な場合のみ）
build-multi:
	@echo "Building multi-arch image for $(IMAGE_NAME)..."
	docker buildx build --platform linux/arm64,linux/amd64 -t $(IMAGE_NAME):latest --push .

# コンテナ起動
run:
	@echo "Running $(IMAGE_NAME) container..."
	docker run --rm -d --init --name $(IMAGE_NAME) \
		--env-file .env \
		$(IMAGE_NAME):$(IMAGE_TAG)

# ログ閲覧
logs:
	docker logs -f $(IMAGE_NAME)

test-slack:
	docker run --rm --env-file .env $(IMAGE_NAME):$(IMAGE_TAG) yarn ts-node test-slack.ts

test-login:
	docker run --rm --env-file .env $(IMAGE_NAME):$(IMAGE_TAG) yarn ts-node test-login.ts

test-notification:
	docker run --rm --env-file .env twins-notification:arm64 yarn ts-node test-notification.ts

# コンテナ停止
stop:
	docker stop $(IMAGE_NAME) || true

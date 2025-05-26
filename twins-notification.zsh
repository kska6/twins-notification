#!/bin/zsh

export PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin
eval $(grep -E '^(TWINS_NOTIFICATION_PROJECT_PATH|TWINS_NOTIFICATION_LOG_PATH)=' ~/.env)
if [[ -z "$TWINS_NOTIFICATION_PROJECT_PATH" || -z "$TWINS_NOTIFICATION_LOG_PATH" ]]; then
	echo "Environment variables TWINS_NOTIFICATION_PROJECT_PATH or TWINS_NOTIFICATION_LOG_PATH are not set."
	exit 1
fi

cd "$TWINS_NOTIFICATION_PROJECT_PATH" || exit 1
/bin/date -Iseconds >> "$TWINS_NOTIFICATION_LOG_PATH"
/usr/bin/make run >> "$TWINS_NOTIFICATION_LOG_PATH" 2>&1

// send-test.ts
import axios from 'axios';

(async () => {
  const url = process.env.SLACK_WEBHOOK_URL;
  if (!url) {
    console.error("SLACK_WEBHOOK_URL not set");
    process.exit(1);
  }

  await axios.post(url, {
    text: '🚀 DockerコンテナからのSlackテスト通知です！',
  });

  console.log('✅ Slackに送信しました');
})();

import 'dotenv/config';
import puppeteer from 'puppeteer';

(async () => {
  // 環境変数から設定を取得
  const baseUrl = process.env.BASE_URL;
  const userId = process.env.TWINS_USER_ID;
  const password = process.env.TWINS_PASSWORD;
  const execPath = process.env.PUPPETEER_EXECUTABLE_PATH;

  if (!baseUrl || !userId || !password) {
    console.error('Environment variables BASE_URL, TWINS_USER_ID, and TWINS_PASSWORD must be set.');
    process.exit(1);
  }

  // Puppeteerブラウザの起動（必要に応じて実行ファイルパスを指定）
  const browser = await puppeteer.launch({
    headless: true,  // ヘッドレスモード（必要に応じてfalseに変更可能）
    executablePath: execPath || undefined,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();

  try {
    // TWINSログインページに遷移
    await page.goto(baseUrl, { waitUntil: 'networkidle0' });
    
    // ユーザーID入力欄が表示されるまで待機し、IDとパスワードを入力
    await page.waitForSelector('input[name="userName"]', { visible: true });
    await page.type('input[name="userName"]', userId);
    await page.type('input[name="password"], input[name="j_password"]', password);
    
    // フォーム送信（Enterキー押下でログイン）
    await page.keyboard.press('Enter');
    
    // ログイン後のページ遷移を待機
    await page.waitForNavigation({ waitUntil: 'networkidle0' });
    
    // トップページ上に「掲示板」という文字を含む要素が現れるまで待機
    await page.waitForFunction(
      () => document.evaluate("//*[contains(text(), '掲示板')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue !== null,
      { timeout: 10000 }
    );
    
    console.log('📄 ページタイトル:', await page.title());
    console.log('🔍 現在のURL:', page.url());
    console.log('✅ ログインに成功しました');
  } catch (err) {
    console.error('ログイン処理中にエラーが発生しました:', err);
  } finally {
    await browser.close();
  }
})();

# 🤖 local_ai - 最高品質ローカルAI環境

本リポジトリは、このPCのマシンスペック（AMD Ryzen 5 3600 / 8GB RAM / NVIDIA GeForce GTX 1650 4GB VRAM）向けに最適化された**ローカルAI環境（Ollama + WebチャットUI + ベンチマーク・ドキュメント）**の統合リポジトリです。

---

## 🚀 すぐに使う（ワンクリック起動）

フォルダ直下の **`Start-Chat.bat`** をダブルクリックするだけで、Ollamaサービスの起動確認とWebチャット画面（ブラウザ）が自動で開きます。

```
local_ai/
└── Start-Chat.bat   <-- これをダブルクリック！
```

### Webチャット画面の主な特徴
- **完全ローカル動作**: インターネット接続不要でプライベートに会話可能
- **リアルタイム・ストリーミング**: 生成された文字が流れるように順次表示
- **思考プロセスの可視化**: DeepSeek-R1などの `<think>` タグを折りたたみブロックとしてスマートに表示
- **コードハイライト & コピー**: プログラミングコードのシンタックスハイライトおよびワンクリックコピー対応
- **モデル切替**: `llama3.1:8b`、`deepseek-r1:7b`、`qwen2.5:3b` などをUI上で即時切り替え可能

---

## 🏆 搭載モデルと検証結果（賢さ重視）

本PCスペック（8GB RAM / 4GB VRAM）の実機で複数モデルをベンチマーク比較した結果です。

| モデル名 | サイズ | 総合賢さ | 日本語品質 | 推論速度 | 特徴・使い分け |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **`llama3.1:8b`** ⭐ **【推奨】** | 4.9 GB | **極めて高い** | **最高** | ~3-4 tok/s | **本PCで動く最高知能モデル**。論理思考・日本語ビジネス文書・並行処理設計・JSON指示追従すべてでトップ。賢さを最優先する用途に最適。 |
| **`deepseek-r1:7b`** | 4.7 GB | **高い (CoT)** | 良好 | ~3-4 tok/s | 思考プロセス（Chain-of-Thought）を展開する推論特化型。数学や難解なパズルの段階的思考に最適。 |
| **`qwen2.5:3b`** | 1.9 GB | 高い | 高い | ~15-20 tok/s | VRAM内に完全収まる超高速モデル。速度と賢さのバランスが秀逸。日常の軽作業向け。 |
| **`gemma2:2b`** | 1.6 GB | 標準 | 高い | ~20-25 tok/s | Google開発の軽量モデル。要約や簡易アシスタントに最適。 |

> 詳しい実測ベンチマーク数値や詳細比較は [`docs/evaluation_report.md`](docs/evaluation_report.md) をご覧ください。

---

## 📁 ディレクトリ構成

```
local_ai/
├── Start-Chat.bat                 # 【起動用】ワンクリックでOllamaとチャットUIを起動
├── README.md                      # 本ドキュメント
├── chat-ui/                       # WebチャットUI資材
│   ├── index.html                 # チャットUI本体（HTML5 / JS / CSS）
│   ├── Start-Chat.bat             # chat-ui単体起動用スクリプト
│   └── README.md                  # チャットUIの技術仕様
├── benchmark/                     # 実機ベンチマークスイート
│   ├── run_benchmark.ps1          # 自動ベンチマーク実行スクリプト
│   ├── prompts.json               # 評価用プロンプト集（論理・日本語・コーディング・JSON）
│   ├── generate_report.ps1        # レポート自動生成スクリプト
│   ├── benchmark_results.json     # 実機テスト実行ログ・スコア生データ
│   └── outputs/                   # 各モデルが出力した回答テキストファイル群
├── docs/                          # 詳細レポート・評価資料
│   └── evaluation_report.md       # ハードウェア分析＆実機検証詳細レポート
└── scripts/                       # 運用・メンテナンス用スクリプト
    ├── start_ollama.ps1           # Ollamaバックグラウンド起動
    └── check_status.ps1           # サービス状態・搭載モデル・VRAM/RAM確認
```

---

## 🔧 Git / GitHub 連携について

### 1. Gitのセットアップ状況
- 本環境にはポータブル版Git（MinGit 2.56.0）が `%LOCALAPPDATA%\Programs\Git` にインストールされ、ユーザー環境変数 `PATH` に追加されています。
- 新しく開いたPowerShellやコマンドプロンプトでそのまま `git` コマンドが利用可能です。

### 2. GitHubへのプッシュ方法
本リポジトリは GitHub（`miiiwa3330/local_ai`）と接続されています。変更をコミットしてGitHubへ反映する場合の手順です。

#### 変更のコミット例:
```powershell
cd C:\Users\Owner\Documents\dev\local_ai
git add .
git commit -m "feat: Add local AI chat UI, benchmark suite, and evaluation report"
```

#### GitHubへのプッシュ（認証）:
現在リモートURLはHTTPS（`https://github.com/miiiwa3330/local_ai.git`）に設定されています。
プッシュ時に認証が求められた場合は、以下のいずれかで認証を行ってください。

1. **GitHub Personal Access Token (PAT)** を使用する場合:
   - `git push origin main` 実行時、ユーザー名とPersonal Access Token（パスワード代わり）を入力。
2. **SSH接続（`git@github.com:...`）を使用する場合**:
   - `ssh-keygen -t ed25519 -C "your_email@example.com"` で鍵を生成
   - `~/.ssh/id_ed25519.pub` の中身を GitHub の Settings -> SSH and GPG keys に登録
   - リモートURLを切り替え: `git remote set-url origin git@github.com:miiiwa3330/local_ai.git`
   - `git push origin main`

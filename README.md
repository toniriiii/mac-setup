# Mac 초기 세팅 스크립트

새 맥에서 처음부터 바로 실행 가능한 개인 세팅 스크립트입니다.

## 사용법

### 1. 이 레포 클론 (git 없어도 됨 — Xcode CLT가 먼저 설치됨)

```bash
# setup.sh가 Xcode CLT → Homebrew → git 순서로 알아서 설치함
# USB 등으로 파일을 옮기거나, GitHub에 올려두고 curl로 받아도 됨
```

### 2. 실행

```bash
cd ~/mac-setup
bash setup.sh
```

## 설치되는 것들

| 분류 | 항목 |
|------|------|
| 기본 CLI | git, curl, wget, tree, jq, gnu-sed, nmap 등 |
| Node.js | fnm + LTS 버전 자동 설치 |
| Python | pyenv + pyenv-virtualenv |
| Java | jenv |
| 패키지 매니저 | pnpm, bun |
| Shell | zsh + antigen + oh-my-zsh + spaceship-prompt |
| 개발 앱 | iTerm2, VS Code, Cursor, Postman |
| 브라우저 | Google Chrome |
| 협업 | Slack, Notion, Discord, Zoom |
| AI | Claude Desktop |
| 미디어 | IINA, VLC |

## 별도 설치 필요 (자동화 어려운 것들)

- **Figma** — figma.com 에서 다운로드
- **Charles** — charlesproxy.com 에서 다운로드
- **KakaoTalk** — App Store
- **Microsoft Office** — 회사 라이선스로 설치
- **Whale 브라우저** — whale.naver.com
- **회사 보안 앱** (SentinelOne, Ivanti VPN 등) — IT팀 통해 설치

## 민감 정보 관리

API 키 등 민감한 환경변수는 `~/.zshrc.local` 파일에 저장하세요.
이 파일은 `.gitignore`에 포함되어 있어 커밋되지 않습니다.

```bash
# ~/.zshrc.local 예시
export ANTHROPIC_API_KEY="sk-ant-..."
```

## 파일 구조

```
mac-setup/
├── setup.sh          # 메인 설치 스크립트
├── Brewfile          # Homebrew 패키지/앱 목록
├── configs/
│   ├── .zshrc        # zsh 설정
│   └── .aliases      # 단축 명령어 모음
└── README.md
```

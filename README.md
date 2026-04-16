# u_ok
情绪管理

u_ok/
├── lib/
│   ├── main.dart                          # 应用入口
│   ├── models/
│   │   ├── emotion_record.dart            # 情绪记录模型
│   │   ├── detective_log.dart             # 侦探追问日志模型
│   │   └── achievement.dart               # 成就模型
│   ├── providers/
│   │   └── app_state_provider.dart        # 全局状态管理
│   ├── screens/
│   │   ├── home_screen.dart               # 首页（包含Dashboard）
│   │   ├── record_screen.dart             # 情绪记录页
│   │   ├── quick_release_screen.dart      # 快速释放页（呼吸/宣泄/语录）
│   │   ├── detective_screen.dart          # 侦探追问页（Pro功能）
│   │   ├── insights_screen.dart           # 洞察分析页（空文件，待实现）
│   │   ├── achievements_screen.dart       # 成就页面
│   │   ├── settings_screen.dart           # 设置页
│   │   └── subscription_screen.dart       # 订阅页
│   ├── services/
│   │   ├── database_service.dart          # 数据库服务
│   │   ├── achievement_service.dart       # 成就服务
│   │   └── payment_service.dart           # 支付服务
│   ├── widgets/
│   │   └── pro_lock_overlay.dart          # Pro功能锁遮罩
│   └── utils/
│       ├── constants.dart                 # 常量定义
│       └── daily_checkin.dart             # 每日签到工具
├── pubspec.yaml                           # 依赖配置
└── ...
# u_ok
情绪管理

lib/
├── main.dart                 # 入口文件，初始化数据库和主题
├── models/
│   ├── emotion_record.dart   # 核心数据模型 (对应 records 表)
│   └── detective_log.dart    # 侦探追问数据模型 (对应 detective_logs 表)
├── services/
│   ├── database_service.dart # SQLite 数据库操作 (sqflite)
│   └── payment_service.dart  # 模拟付费状态管理 (InAppPurchase 占位)
├── providers/
│   └── app_state_provider.dart # 全局状态管理 (付费状态, 用户设置等)
├── screens/
│   ├── home_screen.dart      # 首页：情绪记录入口 + 列表预览
│   ├── record_screen.dart    # 模块1：情绪记录表单
│   ├── detective_screen.dart # 模块2：侦探追问 (专业版限制)
│   ├── insights_screen.dart  # 模块3：洞察分析 (专业版限制)
│   ├── settings_screen.dart  # 模块5：设置与隐私
│   └── subscription_screen.dart # 模块6：付费解锁页面
├── widgets/
│   ├── emotion_selector.dart # 情绪选择组件
│   ├── intensity_slider.dart # 强度滑动条
│   ├── scene_chips.dart      # 场景选择 Chips
│   └── pro_lock_overlay.dart # 专业版锁定遮罩层
└── utils/
    ├── constants.dart        # 常量定义 (颜色, 预设场景等)
    └── date_helper.dart      # 时间处理工具

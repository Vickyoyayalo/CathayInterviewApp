# 📱 CathayInterviewApp

**CathayInterviewApp** 是國泰金控 iOS 面試開發的一款測試應用，我完整實現了題目要求的功能，並額外挑戰了 **Plus 加分題**。
以下為專案概覽：

---

## 🔧 **開發環境**
- **開發工具**: Xcode 15.4
- **語言**: Swift
- **模擬器**: iPhone 15 Pro (iOS 17.5)
- **架構**: MVC + MVVM (分層管理 UI 和業務邏輯)
- **第三方套件**: **無**（全程採用原生方法實作）



## 🚀 **實作功能**
### 核心功能
1. **Pull-to-Refresh**
   - 完全原生實作，使用 `UIRefreshControl` 整合 TableView，並結合 API 呼叫更新數據。
   - 提供即時通知與金額數據更新功能。
2. **Bell Notification**
   - **狀態更新**：在收到新通知後，通知圖示上動態顯示紅點。
   - 點擊紅點後進入通知列表，並可即時清除通知。
3. **Hidden/Visible Amount**
   - 點擊「眼睛圖示」切換金額隱藏與顯示模式 (`******` or actual value)。
   - 金額顯示支持格式化（如 `$1,234.56`）。
4. **Ad Banner**
   - 橫幅廣告自動輪播（每 3 秒切換）。
   - 支持手動滑動切換。
5. **Favorite List**
   - 實現 Favorites 的拉動更新，支持列表滑動與顯示。



## ⭐ **加分功能 (Plus)**
1. **部分 Loading 動畫**
   - 在每次進行 API 請求時，動態顯示 Loading 指示器（使用原生 `UIActivityIndicatorView` 實現）。
2. **Swipe 功能**
   - 對 Favorites 列表的項目添加滑動手勢，支持刪除操作。
3. **Error Handling**
   - 增加 API 錯誤處理邏輯，保證網路中斷或伺服器返回錯誤時有明確的提示。



## 🛠️ **技術亮點**
1. **MVC 與 MVVM 混合架構**
   - 將視圖控制器（ViewController）拆分為單一職責，並透過 ViewModel 負責業務邏輯和數據綁定。
   - 提升代碼可讀性與可維護性，並有效減少視圖控制器的程式碼膨脹。
   
2. **無第三方套件，純原生開發**
   - Pull-to-Refresh 功能完全依靠 `UIRefreshControl` 整合而成。
   - 使用 URLSession 管理 API 請求，並手動解析 JSON 數據至模型結構。

3. **API 數據管理**
   - 動態獲取通知列表、金額數據、喜愛清單與廣告橫幅。
   - API 數據與介面同步更新，保證流暢的用戶體驗。

4. **動態 UI 更新**
   - 即時狀態變化（如 Bell 的紅點、金額隱藏/顯示切換）皆通過原生 UIKit 動畫完成。



## 📋 **架構圖**
```
CathayInterviewApp
├── 📁 AppDelegate
├── 📁 SceneDelegate
├── 📁 Manager
│     └── NotificationManager.swift
├── 📁 Model
│     ├── Notification.swift
│     └── Favorite.swift
├── 📁 Service
│     └── APIService.swift
├── 📁 View
│     ├── MainViewController.swift
│     ├── MainTabBarController.swift
│     ├── FavoriteListView.swift
│     ├── AdBannerView.swift
│     ├── PlaceholderCell.swift
│     ├── BannerCell.swift
│     ├── MenuIconsView.swift
│     ├── GradientMaskView.swift
│     ├── NotificationListViewController.swift
│     ├── NotificationCell.swift
│     ├── FavoriteCell.swift
│     └── AccountBalanceView.swift
├── 📁 ViewModel
│     ├── MainViewModel.swift
│     ├── FavoriteListViewModel.swift
│     ├── NotificationListViewModel.swift
│     ├── AdBannerViewModel.swift
│     └── AccountBalanceViewModel.swift
├── 📁 Resources
│     ├── 📁 Font
│     │     ├── SF-Pro-Text-Bold
│     │     ├── SF-Pro-Text-Regular
│     │     └── Font
│     ├── 📁 Assets
│     └── 📁 Main
│           └── LaunchScreen
└── 📁 Extensions
      └── Extension+UIColor.swift
```



## 🔍 **安裝與測試**
1. **Clone 專案**
   ```bash
   git clone https://github.com/yourusername/CathayInterviewApp.git
   ```
2. **開啟專案**
   ```bash
   cd CathayInterviewApp
   open CathayInterviewApp.xcodeproj
   ```
3. **模擬器執行**
   - 選擇 **iPhone 15 Pro (iOS 17.5)** 模擬器。
   - 按下 **Cmd + R** 進行編譯與執行。



## 📞 **聯繫我**
- **Email**: vickyoyaya@gmail.com
- **LinkedIn**: [linkedin.com/in/vickyishere](https://www.linkedin.com/in/vickyishere/)
- **GitHub**: [github.com/Vickyoyayalo](https://github.com/Vickyoyayalo)



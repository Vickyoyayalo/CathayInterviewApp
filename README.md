# 📱 CathayInterviewApp

**CathayInterviewApp** 是一款專為國泰金控 iOS 面試開發的測試應用

感謝國泰金控提供這次寶貴的面試機會，我針對指定需求開發了 CathayInterviewApp，基於 UIKit 完成所有核心功能，並挑戰多項加分功能以提升用戶體驗與應用效能。專案設計中注重架構規劃與代碼品質，力求展現對細節的專注。

期望能藉由此專案，與國泰金控團隊合作，結合我的技術專長，助力貴公司打造更優質的數位化產品！

專案實作概要如下：

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

### 🔴 **通知列表的動態紅點更新**
- **功能亮點**：
  - 實現通知紅點顯示邏輯：有新通知時顯示紅點，點擊後清除。
- **技術實現**：
  - 動態綁定數據與界面，通過 ViewModel 即時更新通知狀態。

### ✨ **動態 Loading 動畫**
- **功能亮點**：
  - 在 API 請求期間展示光影過渡效果，提示用戶正在加載。
- **技術實現**：
  - 使用自定義 `GradientMaskView` 結合 `CAGradientLayer` 和 `CABasicAnimation`，無需依賴第三方工具。

### 🖐️ **Favorite List 的手勢操作**
- **功能亮點**：
  - 長按拖動：支持用戶長按 Favorite 項目，進行拖動排序並即時更新數據。
  - 左右滑動：支持左滑刪除、右滑標記重要操作，交互直觀。
  - 頁面切換：每頁顯示 4 個項目，用戶可快速切換多頁數據。
- **技術實現**：
  - 使用 `UILongPressGestureRecognizer` 和 `UISwipeGestureRecognizer` 實現自定義手勢。
  - 結合 `UICollectionView` 的內建交互方法處理手勢與滾動協作。

### 🔄 **橫幅廣告自動與手動輪播**
- **功能亮點**：
  - 自動輪播：每 3 秒自動切換廣告，並同步更新頁面指示器。
  - 手動滑動：支持用戶左右滑動切換廣告，滑動後暫停輪播，延遲恢復。
  - 視覺效果：利用圓角與陰影增強廣告視圖的 UI 表現。
- **技術實現**：
  - 使用 `Timer` 和 `scrollView` 事件處理自動與手動行為。
  - 無第三方庫，基於 `UICollectionViewFlowLayout` 完成。

## 🔧 **加分功能技術總結**
1. **全原生實現**：所有功能均基於 UIKit，未依賴第三方套件。
2. **用戶體驗優化**：手勢交互與動態效果結合，提升操作直觀性。
3. **高效數據處理**：採用 ViewModel 確保數據與界面同步更新，增強項目結構的可維護性。

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



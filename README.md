# 📱 Cathay Interview App

App 名稱: **瑋琪 iOS 面試**  
專為國泰金控 iOS 面試開發的 app。

感謝國泰金控提供這次寶貴的面試機會，我針對指定需求開發了 **CathayInterviewApp**，基於 UIKit 完成所有核心功能，並挑戰多項加分功能以提升用戶體驗與應用效能。專案設計中注重架構規劃與代碼品質，力求展現對細節的專注。

期望能藉由此專案，與國泰金控團隊合作，結合我的技術專長，助力貴公司打造更優質的數位化產品！

---

## 🗂️ 目錄
- [🔧 開發環境](#-開發環境)
- [🚀 實作功能](#-實作功能)
- [⭐ 加分功能實作 (Plus)](#-加分功能實作-plus)
- [🛠️ 技術亮點](#️-技術亮點)
- [📋 架構圖](#-架構圖)
- [🌳 Git Flow 開發流程](#-git-flow-開發流程)
- [🔍 安裝與測試](#-安裝與測試)
- [📞 嗨～歡迎聯繫我](#-請聯繫我)

---

## 🔧 **開發環境**
- **開發工具**: Xcode 15.4
- **語言**: Swift
- **框架**: UIKit
- **模擬器**: iPhone 15 Pro (iOS 17.5)
- **架構**: MVC + MVVM (分層管理 UI 和業務邏輯)
- **第三方套件**: **無**（全程採用原生方法實作）

---

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

---

## ⭐ **加分功能實作 (Plus)**

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
  - 左右滑動：支持左滑刪除、右滑操作，交互直觀。
  - 頁面切換：每頁顯示 4 個項目，用戶可快速切換下一頁數據。
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

---

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

---

## 📋 **架構圖**
<details>
<summary>點擊查看完整架構圖</summary>

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
│     ├── FavoriteListView.swift
│     ├── AdBannerView.swift
│     ├── PlaceholderCell.swift
│     ├── BannerCell.swift
│     ├── MenuIconsView.swift
│     ├── GradientMaskView.swift
│     ├── NotificationCell.swift
│     ├── FavoriteCell.swift
│     └── AccountBalanceView.swift
├── 📁 ViewController
│     ├── MainTabBarController.swift
│     ├── MainViewController.swift
│     └── NotificationListViewController.swift
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
</details>


---

## 🌳 **Git Flow 開發流程**
在開發 **CathayInterviewApp** 的過程中，我採用了 **Git Flow** 工作流程，確保功能開發、版本控制與代碼整合的清晰性與高效性。

以下為開發流程概述：

### 1️⃣ **分支架構**
- **`main` 分支**：用於存放穩定版本代碼，所有已測試完成的功能均從此分支發布。
- **`develop` 分支**：作為功能整合的基礎分支，所有功能分支均基於此分支進行開發與合併。


### 2️⃣ **功能開發流程**
1. **功能分支**：
   - 每項功能均在 **`feature/[功能名稱]`** 分支上開發。
   - 功能完成後提交 Pull Request，通過審查後合併回 `develop` 分支。

2. **分支命名規範**：
   - **功能開發分支**：`feature/[功能名稱]`（例：`feature/ad-banner`）
   - **Refactor分支**：`refactor/[修復名稱]`（例：`refactor/mainViewController`）

3. **分支整合**：
   - 功能開發完成後，合併至 `develop` 進行功能整合。
   - 在功能穩定後，定期將 `develop` 合併至 `main`，生成穩定版本。

### 3️⃣ **主要功能分支**

| **分支名稱**             | **描述**                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| `feature/notification-red-dot` | 修復通知紅點的未讀狀態邏輯，避免重複顯示錯誤。                                 |
| `feature/eye-toggle`    | 實現眼睛按鈕切換金額顯示/隱藏功能。                                             |
| `feature/notification-list` | 實現通知列表的動態紅點顯示與未讀狀態管理。                                      |
| `feature/account-balance` | 實現金額隱藏/顯示與 GradientMaskView 的動態效果。                             |
| `feature/favorite-list` | 實現 Favorite List 的長按拖動、滑動操作與 More Button 分頁顯示功能。                            |
| `feature/ad-banner`     | 實現橫幅廣告的自動輪播與手動滑動功能。                                         |

---
## 📱 **實作成果**

### 1️⃣** 動態 Loading ，換Tab也不間斷**

https://github.com/user-attachments/assets/b96909b9-4137-475a-98bf-a7db6d1b95b7

### 2️⃣**用戶長按 Favorite 項目，進行拖動排序並即時更新數據**

https://github.com/user-attachments/assets/6987e878-f35f-4254-9baf-550a9f5e3efb

### 3️⃣**橫幅廣告自動與手動輪播**

https://github.com/user-attachments/assets/264a62ea-0d08-45ea-9f0b-81e1983d55ca

---

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

## 📞 **請聯繫我**
- **Email**: vickyoyaya@gmail.com
- **LinkedIn**: [linkedin.com/in/vickyishere](https://www.linkedin.com/in/vickyishere/)
- **GitHub**: [github.com/Vickyoyayalo](https://github.com/Vickyoyayalo)



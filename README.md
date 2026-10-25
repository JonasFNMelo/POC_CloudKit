<div align="center">

# POC_CloudKit

### A tiny social network with iCloud as the whole backend. ☁️

POC_CloudKit is a proof of concept of a minimal social app built entirely on CloudKit:
users get a profile from their iCloud identity, publish posts with text and images, and
choose whether each post goes to the **public** database for everyone or stays in their
**private** iCloud — no custom server, no login screen.

<br/>

[![Platform](https://img.shields.io/badge/iOS-26.2+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-0052CC?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![CloudKit](https://img.shields.io/badge/CloudKit-3693F3?style=for-the-badge&logo=icloud&logoColor=white)](https://developer.apple.com/icloud/cloudkit/)

</div>

---

## 📑 Table of Contents

- [About](#-about)
- [What This POC Validates](#-what-this-poc-validates)
- [How It Works](#-how-it-works)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Authors](#-authors)

---

## 📖 About

This project was built to answer one question before using CloudKit in a production app:
*can CloudKit alone handle users, posts, privacy and relationships between records?*
It exercises the public and private databases side by side, record references, queries
and image storage, all behind a single service layer with `async/await`.

---

## ✅ What This POC Validates

- **🗂️ Public and private databases** of the same `CKContainer`, used side by side.
- **🪪 Identity without login** — the iCloud `userRecordID` creates a private `PrivateUser` record linked to a public `User` profile.
- **🔗 Record relationships** — each `Post` references its author with `CKRecord.Reference` (`.deleteSelf`), and the user keeps references to their posts.
- **🔎 Queries** with `CKQuery` + `NSPredicate`, including fetching every post of a user by reference.
- **🖼️ Images** stored as `Data` inside the record.
- **🔁 Model mapping** between Swift structs and `CKRecord` (`toDictionary()` / `fromRecord(_:)`).

---

## ⚙️ How It Works

1. **First launch** — the app reads the iCloud user ID and saves a private and a public user record.
2. **Create a post** — write text, pick images and choose public or private.
3. **Feed** — public posts are fetched together with their authors.
4. **Profile** — shows every post published by a user.

Under the hood, `CloudKitService` is the only type that talks to CloudKit, exposing
`async` methods for save, fetch, query and delete. View models (`ContentViewModel`,
`CreatPostSheetViewModel`, `ProfileViewModel`) build on it, and views never touch
CloudKit directly.

---

## 🛠️ Tech Stack

| Area | Tech |
|------|------|
| UI | SwiftUI · PhotosUI |
| Backend | CloudKit (public + private databases) |
| State | Observation (`@Observable`) |
| Architecture | MVVM + service layer |

---

## 📂 Project Structure

```
POC_CloudKit/
├── POC_CloudKitApp.swift       # App entry
├── Services/                   # CloudKitService — single entry point to CloudKit
├── Models/                     # Post, User, PrivateUser, PostWithUser, RecordType
├── ViewModels/                 # Feed, post creation and profile view models
└── Views/                      # Feed, post creation sheet, profile
```

---

## 🎯 Getting Started

### Requirements

- Xcode 26+
- iOS 26.2+
- An Apple Developer account and an iCloud account signed in on the simulator or device

### Run

```bash
git clone https://github.com/JonasFNMelo/POC_CloudKit.git
cd POC_CloudKit
open POC-CloudKit.xcodeproj
```

Then set your own **Signing Team** and replace the iCloud container
(`iCloud.JonasMelo.POCCloudKit`) with one your team owns. In the CloudKit Console, create
the `User`, `PrivateUser` and `Post` record types and mark the fields used in filters
(`id`, `privateID`, `userID`) as queryable.

---

## 👥 Authors

<table width="100%">
  <tr>
    <td align="center" width="100%">
      <a href="https://github.com/JonasFNMelo"><img src="https://github.com/JonasFNMelo.png" width="80" alt="Jonas Melo"/></a>
      <br/><sub><b>Jonas Melo</b></sub><br/>
      <a href="https://github.com/JonasFNMelo"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/jonas-melo-/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
  </tr>
</table>

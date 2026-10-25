# POC_CloudKit

Prova de conceito de uma **rede social mínima sobre CloudKit**: cada usuário tem um perfil, publica posts com texto e imagens e escolhe se o post vai para o banco **público** (visível para todos) ou **privado** (só no iCloud dele). Sem servidor próprio — todo o backend é o iCloud.

> 📸 _Screenshots em breve._

## O que a POC valida

- **Bancos público e privado** do `CKContainer` usados lado a lado
- **Identidade do usuário** a partir do `userRecordID` do iCloud: um registro `PrivateUser` (privado) ligado a um `User` público, sem login próprio
- **Relacionamentos com `CKRecord.Reference`**: cada `Post` aponta para o seu autor (com `action: .deleteSelf`) e o usuário guarda as referências dos seus posts
- **Consultas com `CKQuery` + `NSPredicate`**, incluindo a busca de todos os posts de um usuário pela referência
- **Imagens** salvas como `Data` no próprio registro
- Mapeamento entre modelos Swift e `CKRecord` (`toDictionary()` / `fromRecord(_:)`)

## Arquitetura

MVVM com uma camada de serviço:

```
POC_CloudKit/
├── Services/
│   └── CloudKitService.swift   # Único ponto de acesso ao CloudKit (async/await)
├── Models/                     # Post, User, PrivateUser, PostWithUser, RecordType
├── ViewModels/                 # ContentViewModel, CreatPostSheetViewModel, ProfileViewModel
└── Views/                      # ContentView, CreatPostSheet, ProfileView
```

Todas as chamadas ao CloudKit usam as APIs `async` (`records(matching:)`, `save`, `record(for:)`), e as Views nunca falam com o CloudKit diretamente.

## Tecnologias

- Swift 5 · SwiftUI · Observation (`@Observable`)
- CloudKit
- PhotosUI

## Requisitos

- Xcode 26 ou superior
- iOS 26.2 ou superior
- Conta Apple Developer e um iCloud logado no simulador ou no dispositivo

## Como rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/JonasFNMelo/POC_CloudKit.git
   ```
2. Abra `POC-CloudKit.xcodeproj` no Xcode.
3. Em **Signing & Capabilities**, selecione o seu time e troque o container do iCloud (`iCloud.JonasMelo.POCCloudKit`) por um container seu.
4. No CloudKit Console, crie os tipos de registro `User`, `PrivateUser` e `Post` e marque como consultáveis (*queryable*) os campos usados nos filtros (`id`, `privateID`, `userID`).
5. Execute (`⌘R`) com uma conta iCloud logada.

## Autor

- [**Jonas Melo**](https://github.com/JonasFNMelo)

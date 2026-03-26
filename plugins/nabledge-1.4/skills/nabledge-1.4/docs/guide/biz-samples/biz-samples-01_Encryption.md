# データの暗号化

## 概要

データの暗号化／復号に必要な機能を提供する。

<details>
<summary>keywords</summary>

データ暗号化, 復号, 暗号化機能提供

</details>

## 特徴

- **暗号機能の隠蔽**: 利用者は暗号方式を意識することなくデータの暗号化/復号を行える。
- **暗号化機能の変更性の向上**: テスト時に暗号化を行わず平文で出力するといった変更を、呼び出し元を変更することなく実現できる。
- **基本的な暗号機能の提供**: [implementated](#s2) に記述されている暗号方式であれば、カスタマイズすることなく利用できる。

<details>
<summary>keywords</summary>

暗号機能の隠蔽, 暗号化変更性, テスト時平文出力, AES暗号化

</details>

## 要求

**実装済み**
- AES128ビット方式の暗号化/復号機能

**未実装**
- DES方式の暗号化/復号機能
- RSA方式の暗号化/復号機能
- DUKPT方式の暗号化/復号および鍵管理機能
- 基本的な鍵管理機能
- 暗号鍵、メタ情報管理機能

**未検討**
- iOS Keychainによる鍵管理機能

<details>
<summary>keywords</summary>

AES128ビット, 実装済み暗号方式, 未実装暗号方式, DES, RSA, DUKPT, iOS Keychain, 鍵管理

</details>

## 構造

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `NMEncryption` | 暗号化/復号を行うためのインタフェース。暗号方式ごとに実装クラスを作成する。本インタフェースを実装したクラス及びインスタンスを暗号クラスと呼ぶ。 |
| `NMKeyManager` | 鍵管理を行うインタフェース。鍵管理方式ごとに実装クラスを作成する。本インタフェースを実装したクラス及びインスタンスを鍵管理クラスと呼ぶ。 |

**クラス**:

| クラス名 | 概要 |
|---|---|
| `NMEncryptionCreator` | 設定書ファイルを元に暗号クラスのインスタンスを生成するクラス。使用方法は :ref:`houToUseEncryption` 参照。 |
| `MNAesEncryption` | AES128ビット暗号化/復号を実装したクラス。設定方法は :ref:`propertyAboutAesEnc` 参照。 |
| `NMPlainTextEncryption` | 暗号化を行わない空実装クラス。 |

<details>
<summary>keywords</summary>

NMEncryption, NMKeyManager, NMEncryptionCreator, MNAesEncryption, NMPlainTextEncryption, クラス構造, インタフェース定義

</details>

## 使用方法

暗号化/復号のために以下の2ステップが必要:
1. プロパティリストの作成
2. APIの呼び出し

**プロパティリスト設定** (`Encryption` キー):

| key | type | 説明 |
|---|---|---|
| Encryption | Dictionary | 暗号クラスの設定 |
| Encryption.class | String | 使用する暗号クラス名 |
| Encryption.initializeList | Dictionary | 使用する暗号クラスの初期値パラメータ群 |

**NMAesEncryption 初期値パラメータ**:

| key | type | 説明 |
|---|---|---|
| keyManager | Dictionary | 鍵管理クラスの設定 |
| keyManager.class | String | 使用する鍵管理クラス名 |
| keyManager.initializeList | Dictionary | 鍵管理クラスの初期値パラメータ |
| mode | String | 動作モード。"CBC"または"ECB"のどちらかを指定可能。 |
| padding | String | パディング種類。"PKCS7"または"NOTHING"のどちらかを指定可能。 |

**NMPlainTextEncryption**: 初期値パラメータなし

**鍵管理クラス**: フレームワーク提供の実装クラスなし

**暗号化実装例** (Objective-C):
```objective-c
NSData *plainData = [@"暗号化対象文字列" dataUsingEncoding:NSUTF8StringEncoding];
// 鍵名称および初期化ベクトルの取得処理は別途実装が必要。
// 初期化ベクトルを使用しない暗号方式の場合はnilを指定できる。
NSData *initializeVector = [self initializeVector];
NSString *keyName = [self keyName];
NSError *error = nil;

id<NMEncryption> encryptor = [NMEncryptionCreator createEncryptionForName:@"設定書ファイル名"];
NSData *encryptData = [self.encryption encryptForKeyName:keyName
                                                    data:plainData
                                           initialVector:initializeVector
                                                   error:&error];
```

**復号実装例** (Objective-C):
```objective-c
NSData *encryptData = [@"gwycQJ0T0qTA\/W+cQBSrzNF6PxZ+vxFQIQBKAFQmzC2" dataUsingEncoding:NSUTF8StringEncoding];
// 鍵名称および初期化ベクトルの取得処理は別途実装が必要。
// 初期化ベクトルを使用しない暗号方式の場合はnilを指定できる。
NSData *initializeVector = [self initializeVector];
NSString *keyName = [self keyName];
NSError *error = nil;

id<NMEncryption> encryptor = [NMEncryptionCreator createEncryptionForName:@"設定書ファイル名"];
NSData *decryptData = [self.encryption decryptForKeyName:keyName
                                                    data:encryptData
                                           initialVector:initializeVector
                                                   error:&error];
```

<details>
<summary>keywords</summary>

NMAesEncryption, プロパティリスト設定, Encryption.class, Encryption.initializeList, keyManager.class, keyManager.initializeList, mode, padding, CBC, ECB, PKCS7, NOTHING, createEncryptionForName, encryptForKeyName, decryptForKeyName, 暗号化実装, 復号実装

</details>

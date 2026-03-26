# モバイルアプリとNablarchサーバ間の通信

## 概要

モバイルアプリとサーバ間での通信機能を提供する。

Nablarch Mobileで提供される各インタフェースの実装クラス。HTTP/HTTPS通信を実装した`NMHttpRequester`とJSONコンバータを実装した`NMJsonConvertor`が提供される。

<details>
<summary>keywords</summary>

モバイルアプリ通信, サーバ間通信, NMHttpRequester, NMJsonConvertor, Nablarch Mobile, 実装クラス一覧

</details>

## 特徴

- **通信機能の隠蔽**: 利用者は通信方式を意識することなくサーバとの通信を行える。
- **基本的な通信機能の提供**: :ref:`aboutHttpConn` に記述された通信機能であれば、カスタマイズなしで利用できる。
- **汎用的な電文の利用**: 送受信する電文形式を自由に変更できる。

## HTTP/HTTPS通信

**クラス**: `NMHttpRequester`（HTTP/HTTPS通信を実装したセンダ）

| 項目 | 仕様 |
|---|---|
| URL | 通信設定ファイルに設定された値。プロトコルが `http` の場合はHTTP通信、`https` の場合はHTTPS通信 |
| メソッド | POST |
| ヘッダ | 特に設定なし |
| 送信ボディ | コンバータによりバイナリデータに変換したメッセージオブジェクト |
| 受信ボディ | ダウンロードデータおよびHTTPステータス（ダウンロードデータがない場合はHTTPステータスのみ） |
| キャッシュ | 使用しない |
| メッセージダンプ | 通信設定ファイルの設定値によってはJSON形式のダンプを行う |
| タイムアウト | 通信設定ファイルに設定された値に従う |

## JSONコンバータ

**クラス**: `NMJsonConvertor`（JSONによる`NMMessage`オブジェクトのエンコード/デコードを実装したコンバータ）

JSON ↔ Objective-C 型変換仕様:

| JSON | Objective-C |
|---|---|
| 数値 | NSNumber（数値、浮動小数点） |
| 文字列 | NSString |
| 真偽値 | NSNumber（真偽値） |
| 配列 | NSArray |
| オブジェクト | NSDictionary |
| null | NSNull |

上記以外のデータ型オブジェクトが`NMMessage`に格納されている場合、バイナリデータへ変換できない。バイト配列を格納する場合はBase64でフォーマットして文字列に変換してから格納すること。`NMMessage`に使用できるキーの型は`NSString`のみ。

<details>
<summary>keywords</summary>

通信機能の隠蔽, 基本的な通信機能の提供, 汎用的な電文の利用, NMHttpRequester, NMJsonConvertor, NMMessage, HTTP通信, HTTPS通信, JSONコンバータ, POST, タイムアウト, Base64, NSNumber, NSString, NSArray, NSDictionary, NSNull, センダ, コンバータ

</details>

## 要求

**実装済み**:
- REST APIを提供するサーバと通信
- HTTP/HTTPS方式の通信
- JSON形式の電文の送受信

**未実装**:
- XML形式の電文の送受信

**未検討**:
- ベーシック認証
- ダイジェスト認証
- 証明書を用いた認証

<details>
<summary>keywords</summary>

実装済み機能, REST API通信, HTTP/HTTPS通信, JSON電文送受信, 未実装, XML電文, ベーシック認証, ダイジェスト認証, 証明書認証

</details>

## 構造

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `NMMessageRequester` | 通信を行うためのインタフェース。通信方式ごとに実装クラスを作成する（実装クラス＝センダ）。 |
| `NMSenderHook` | 通信前後の処理を行うインタフェース（実装クラス＝フック）。 |
| `NMBodyConvertor` | NMMessageインスタンスをバイナリデータに変換するインタフェース。変換形式ごとに実装クラスを作成する（実装クラス＝コンバータ）。 |

## クラス定義

**通信処理**:

| クラス名 | 概要 |
|---|---|
| `NMMessageSender` | 通信機能を提供するクラス。使用方法は :ref:`houToUse` 参照。 |
| `NMHttpRequester` | HTTP/HTTPS通信機能を実装したクラス。設定方法は :ref:`propertyAboutSender` 参照。 |

**通信データ**:

| クラス名 | 概要 |
|---|---|
| `NMMessage` | 通信のペイロード。キーと値を格納するコレクション（NSDictionary相当）。 |

**データ変換**:

| クラス名 | 概要 |
|---|---|
| `NMJsonBodyConvertor` | JSON形式でNMMessageとNSData間の変換機能を提供するクラス。 |

**その他**:

| クラス名 | 概要 |
|---|---|
| `NMConnectionUtil` | 通信機能に関するユーティリティをまとめたクラス。 |
| `NMMockUtil` | 通信モックに関するユーティリティをまとめたクラス。 |

## フック処理順序

フックを複数使用する場合、送信前処理は設定した順番に、送信後処理は設定した逆順に呼び出される（フック設定は :ref:`connectionFWpropertyList` 参照）。

例: フック1（通信ヘッダ設定/取得）、フック2（暗号化対象データのフォーマット/パース）、フック3（データ暗号化/復号）を順に設定した場合:
- 送信前: 1→2→3（ヘッダ設定→フォーマット→暗号化）
- 送信後: 3→2→1（復号→パース→ヘッダ取得）

この仕組みにより、フックの追加・削除が容易（例: テスト時は暗号化フックだけ取り外す）。

<details>
<summary>keywords</summary>

NMMessageRequester, NMSenderHook, NMBodyConvertor, NMMessageSender, NMHttpRequester, NMMessage, NMJsonBodyConvertor, NMConnectionUtil, NMMockUtil, クラス図, シーケンス図, フック処理順序, センダ, コンバータ

</details>

## データモデル

送受信電文のデータモデル:

- **プロトコルヘッダ**: 各通信プロトコル（HTTPなど）のヘッダ情報を格納する領域。アクセスはセンダで行うことを推奨する。
- **メッセージボディ**: プロトコルヘッダを除いた電文のデータ領域。コンバータによって解析され、NMMessageオブジェクトとして扱える。NMMessageオブジェクトはNSDictionaryと同様にキーと値を格納するコレクションクラスである。

<details>
<summary>keywords</summary>

NMMessage, プロトコルヘッダ, メッセージボディ, データモデル, 電文形式

</details>

## 使用方法

メッセージ送信の手順:
1. プロパティリストの作成
2. メッセージの作成
3. 通信処理APIの呼び出し

## プロパティリストの作成

通信設定ファイル（プロパティリスト）のトップレベル項目:

| 項目名 | データ型 | 概要 |
|---|---|---|
| Sender | Dictionary | センダの設定 |
| SenderHook | Array | 通信前後の処理を行う複数のフックの設定 |

**Sender設定**:

| 項目名 | データ型 | 概要 |
|---|---|---|
| class | String | 使用するセンダ名 |
| initializeList | Dictionary | センダの初期化パラメータ |

**SenderHook設定**:

| 項目名 | データ型 | 概要 |
|---|---|---|
| SenderHook[] | Dictionary | 各フックの設定 |
| SenderHook[].class | String | 使用するフック名 |
| SenderHook[].initializeList | Dictionary | フックの初期化パラメータ |

フック処理順序: 送信前処理は配列順、受信後処理は配列逆順に実行される。

### 初期値パラメータ

#### NMHttpRequester

| 項目名 | データ型 | 概要 |
|---|---|---|
| URL | String | 宛先URL |
| timeInterval | Number | 待機タイムアウト時間 |
| dumpMessageEnabled | Boolean | JSON形式でのメッセージダンプ要否 |
| bodyConvertor | Dictionary | コンバータの設定 |
| bodyConvertor.class | String | 使用するコンバータ名 |
| bodyConvertor.initializeList | Dictionary | コンバータの初期化パラメータ |

#### フック

フレームワークで提供する実装クラスなし。フック（`NMSenderHook`実装クラス）はすべてアプリ側で実装する必要がある。

#### NMJsonBodyConvertor

初期値パラメータなし（設定不要）。

## メッセージの作成

```objective-c
NSDictionary *dict = @{
    @"string" : @"dummyString",
    @"number_integer" : @10,
    @"number_double" : @1.0,
    @"number_bool" : @YES,
    @"array" : @[],
    @"object" : @{},
    @"null" : [NSNull null] };
NMMessage *sendMessage = [[NMMessage alloc] initWithDictionary:dict];

// NSDataは文字列にエンコードしてから格納する
NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
[sendMessage setValue:str forKey:@"data"];
```

## 通信処理APIの呼び出し

`NMMessageSender` の `send:sendMessage:error:` メソッドの第一引数に指定した名前と同名のプロパティリストが読み込まれる。

```objective-c
- (NMMessage *)sample {
    NMMessage *sendMessage = [self createSendMessage];
    NMMessageSender *sender = [[NMMessageSender alloc] init];
    
    NSError *error = nil;
    // 第一引数に設定された物と同名の通信設定ファイルが読み込まれる
    // この例だとdestination.plistというプロパティリストが読み込まれる
    NMMessage *response = [sender send:@"destination" sendMessage:sendMessage error:&error];

    return response;
}
```

<details>
<summary>keywords</summary>

NMHttpRequester, NMMessageSender, NMJsonBodyConvertor, プロパティリスト設定, SenderHook, Sender, URL, timeInterval, dumpMessageEnabled, bodyConvertor, 通信処理API, メッセージ作成, フック実装クラスなし, 初期値パラメータなし

</details>

# システム間メッセージング機能

## 概要

Nablarchフレームワークが提供するシステム間メッセージング機能。MOMまたはHTTPを使用して外部システムとメッセージの送受信を行う。

<details>
<summary>keywords</summary>

システム間メッセージング, MOMメッセージング, HTTPメッセージング, 外部システム連携

</details>

## 全体構成

## 実行形式

| 実行形式 | 内容 |
|---|---|
| [enterprise_messaging_mom](libraries-enterprise_messaging_mom.md) | MOMを使用して外部システムとメッセージ送受信。応答不要メッセージ送信、同期応答メッセージ送信、応答不要メッセージ受信、同期応答メッセージ受信の4種類 |
| [enterprise_messaging_http](libraries-enterprise_messaging_http.md) | HTTPを使用して外部システムとメッセージ送受信。HTTPメッセージ送信、HTTPメッセージ受信の2種類 |

## レイヤ構成

| レイヤ | 内容 | MOM | HTTP |
|---|---|---|---|
| フレームワーク機能 | メッセージング基盤APIを使用して実装されたフレームワーク提供機能 | ○ | ○ |
| メッセージング基盤API | メッセージ送受信処理を実行する中心となるクラス群 | ○ | × |
| メッセージングプロバイダ | メッセージング基盤APIの実装系を与えるモジュール | ○ | × |
| 通信クライアント | HTTP通信インターフェースの実装系を使用したHTTP通信の実装 | × | ○ |

> **注意**: 業務アプリケーション開発者はMOM/HTTPを意識する必要はない。アクションクラスや使用するAPIは共通のため、通信経路を意識せずに実装できる。

<details>
<summary>keywords</summary>

MOMメッセージング, HTTPメッセージング, フレームワーク機能, メッセージング基盤API, メッセージングプロバイダ, 通信クライアント, 実行形式, レイヤ構成, 応答不要メッセージ送信, 同期応答メッセージ送信, 応答不要メッセージ受信, 同期応答メッセージ受信

</details>

## 機能詳細

- [enterprise_messaging_mom](libraries-enterprise_messaging_mom.md)
- [enterprise_messaging_http](libraries-enterprise_messaging_http.md)

<details>
<summary>keywords</summary>

enterprise_messaging_mom, enterprise_messaging_http, MOMメッセージング詳細, HTTPメッセージング詳細

</details>

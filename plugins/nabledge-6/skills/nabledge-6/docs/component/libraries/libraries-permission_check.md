# 認可チェック

## 概要

ユーザがシステムの機能を使用する権限を持つかチェックする機能。Nablarchでは以下の2種類の認可チェック機能を提供している:

- [authorization/permission_check](libraries-permission_check.md)
- [authorization/role_check](libraries-role_check.md)

> **補足**: 両機能の使い分け
>
> [authorization/role_check](libraries-role_check.md) は、権限管理のモデル構造を簡素化し、処理とデータの紐づけを一部ハードコーディングすることでデータ管理の煩雑さを軽減している。権限管理の条件が基本的に変わらないシステムで、少ないコストで素早く権限管理を導入したい場合に適している。
>
> 権限管理の条件が変わる可能性があるシステムでは、 [authorization/permission_check](libraries-permission_check.md) が適している（導入コストは高いが、しっかりとしたデータ管理で権限管理が行える）。

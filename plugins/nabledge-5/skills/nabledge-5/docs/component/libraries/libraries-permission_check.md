# 認可チェック

**公式ドキュメント**: [認可チェック](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/permission_check.html)

## 認可チェック機能の選択基準

> **補足**: 2種類の認可チェック機能の使い分け

- [authorization/role_check](libraries-role_check.md): 権限管理のモデル構造を簡素化し、処理とデータの紐づけを一部ハードコーディングすることでデータ管理の煩雑さを軽減。権限管理の条件が基本的に変わらないシステムで、少ないコストで素早く権限管理を導入したい場合に適している。
- [authorization/permission_check](libraries-permission_check.md): 権限管理の条件が変わる可能性があるシステムに適している。導入コストは高まるが、しっかりとしたデータ管理で権限管理が行える。

<details>
<summary>keywords</summary>

認可チェック, 権限チェック, permission_check, role_check, authorization/permission_check, authorization/role_check, 機能選択基準, 権限管理

</details>

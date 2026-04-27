# Excelのテストデータに設定した整数値が、テスト実行時には小数部ありの数値となってしまいます。回避方法を教えてください

> **question:**
> テストデータのExcelに以下のように数値データ(AGE列)を定義した場合、テスト実行時に小数部有りの数値に変換されてしまいます。
> 例えば、1レコード目の「20」は、「20.0」に変換されてしまいます。

> これでは、テストを実施することができないので回避方法を教えてください。

SETUP_TABLE=USERS
<table width="300" style="border:solid 1px; border-collapse: collapse;">
    <tr style="background-color:#ffff99; border:solid 1px; border-collapse: collapse;">
        <th style="border:solid 1px;">USER_ID</th>
        <th style="border:solid 1px;">NAME</th>
        <th style="border:solid 1px;">AGE</th>
    </tr>
    <tr style="border:solid 1px; border-collapse: collapse;">
        <td style="border:solid 1px;">001</td>
        <td style="border:solid 1px;">ほげ</td>
        <td style="border:solid 1px;">20</td>
    </tr>
    <tr style="border:solid 1px; border-collapse: collapse;">
        <td style="border:solid 1px;">002</td>
        <td style="border:solid 1px;">ふが</td>
        <td style="border:solid 1px;">25</td>
    </tr>
    <tr style="border:solid 1px; border-collapse: collapse;">
        <td style="border:solid 1px;">003</td>
        <td style="border:solid 1px;">ほげふが</td>
        <td style="border:solid 1px;">30</td>
    </tr>
</table>

> **answer:**
> Excelに記述するテストデータの書式は全て **文字列書式** で設定してください。
> 文字列書式以外（例えば、標準や数値書式）の場合、Excelに設定されたデータを自動テストFWが正しく読むことができません。

> 詳細は、以下を参照してください。

> * >   **[Nablarchプログラミング・単体テストガイド]** -> **[自動テストフレームワークの使用方法]** -> **[自動テストフレームワーク]** -> **[セルの書式]**

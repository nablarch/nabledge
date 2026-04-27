# ■ボタンのアイコンを変更

プロジェクト用のcancel.tag、confirm.tagを作成することで、ボタンイメージを変更することができます。
nablarch-widget-buttonウィジェットを別名でコピーし、コピーしたものに対して修正を行ってください。
■修正箇所
・キャンセルボタン
以下の行のアイコン指定部分をicon="fa fa-thumbs-down"に差し替えてください。
https://github.com/nablarch/nablarch-plugins-bundle/blob/master/node_modules/nablarch-widget-button/ui_public/WEB-INF/tags/widget/button/cancel.tag#L30
・確定ボタン
以下の行のアイコン指定部分をicon=icon="fa fa-thumbs-up"に差し替えてください。
https://github.com/nablarch/nablarch-plugins-bundle/blob/master/node_modules/nablarch-widget-button/ui_public/WEB-INF/tags/widget/button/confirm.tag#L29

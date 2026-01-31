
# 目的

QIITAの記事を永久に保存することが目的です。
QIITAの記事が300投稿を越えました。
時々、もしもQIITAが終了したらこれらの記事は無くなってしまうのではないかと不安になることがあります。
記事自体はマークダウンでダウンロード出来るらしいのですが、画像等もありやはり不安です。
QIITAは今の所は安泰ですが20年後にどうなっているか分かりません。
2000年代の記事を開こうとするとリンクが切れていることはよくあります。(殆どは個人運営かもしれませんがYahoo!ブログみたいに大手でも終了しているものもあります。)

又、他のブログサイトへ移行するにしても元々QIITAのAWSに保存している画像のURLは全て書き換えなくてはいけません。
よって、今回は2026年から投稿分の記事を全てGITHUBへ保存し、QIITAで上で画像を参照しているURLを全てGITHUB上のデータを指すように書き換えます。

※流石に300以上もの記事を一気にGITHUB上へ移行するのは気力が必要なので、先ずは2026年分から初めて少しずつやっていきます。
　筆者の初期の記事は残す価値が無いものが多いので後からでも問題はありません。

# GITHUB上に記事を上げる

過去に自分で書いた記事を参考にします。
[GITHUB更新方法(備忘録)](https://qiita.com/earthen94/items/a69072825c00c9edbb9f)


レポジトリ作成「https://github.com/ooe1220/articles.git」を作成した。

![newrepo.png](https://raw.githubusercontent.com/ooe1220/articles/master/20260131QIITA%E8%A8%98%E4%BA%8B%E3%82%92GITHUB%E4%B8%8A%E3%81%AB%E4%BF%9D%E5%AD%98/newrepo.png)

コミットします。
![folder.png](https://raw.githubusercontent.com/ooe1220/articles/master/20260131QIITA%E8%A8%98%E4%BA%8B%E3%82%92GITHUB%E4%B8%8A%E3%81%AB%E4%BF%9D%E5%AD%98/folder.png)

コミット後にURLが生成されるので以下の形式で画像を貼り付けます。(この記事が参照している画像は全てGITHUB上にあります)
```
![folder.png](https://raw.githubusercontent.com/ooe1220/articles/master/20260131QIITA%E8%A8%98%E4%BA%8B%E3%82%92GITHUB%E4%B8%8A%E3%81%AB%E4%BF%9D%E5%AD%98/folder.png)
```

※URLを絶対パスにしたいので一旦コミットしてから、記事のURLを編集して再度コミットする流れになります。
　絶対にもっと良い方法があるはずですが、まだ慣れていないのでこの方法で進めます。







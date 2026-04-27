# ■テスト用APIの移動内容

|  |  | No | nablarch-fw-webから移動したAPI / クラス | nablarch-fw-webから移動したAPI / API | nablarch-testingの対応するAPI / クラス | nablarch-testingの対応するAPI / API |
|---|---|---|---|---|---|---|
|  |  | 1 | HttpRequest | public HttpRequest() public HttpRequest(String message) public HttpRequest setCookie(HttpCookie cookie) | MockHttpRequest | public MockHttpRequest() public MockHttpRequest(String message) public HttpRequest setCookie(HttpCookie cookie) |
|  |  | 2 | HttpCookie | public String toString() public static HttpCookie valueOf(String cookieStr) | MockHttpCookie | public String toString() public static HttpCookie valueOf(String cookieStr) |

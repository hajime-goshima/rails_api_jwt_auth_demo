### DeviseJWTシークレットーキー

`rake secret`で生成したシークレットキーを`credentials.yml.enc`に保存しています。（パス：`devise_jwt_secret_key_base`）

### CORS設定

`config/initializers/cors.rb`でcors設定を行います。

デフォルトでは`origin`を`*`で定義しているため、全てのオリジンからのリクエストを受け入れますが、
利用側のフロントオリジンのみを指定することが推奨されます。

詳細はこちらを参照して下さい。  
https://github.com/cyu/rack-cors#configuration-reference

### クッキー認証とJWT認証

Deviseは、下記の条件のいずれかを満たさない限りは、ユーザーセッション（デフォルト：Cookie）で認証を行います。  

- セッションが無効化されている
- config.skip_session_storageに:params_authが含まれている
- Railsリクエストフォージェリが未承認になる（APIモードでは通常、非アクティブ化されている）

そのため、JWT認証を強制するためには下記の設定を行います。

```
config/initializers/devise.rb

config.skip_session_storage = [:http_auth, :params_auth]
```

詳細は下記を参照して下さい。  
https://github.com/waiting-for-dev/devise-jwt#session-storage-caveat

### 失効戦略(Revocation strategies)

devise-jwtでは３つの失効戦略を選択できます。

- JTIMatcher: ユーザモデルのjtiカラムに保存されたトークンと一致するか検証します。これはつまり、１デバイスでしかセッションを維持できません。
- DenyList: 失効したトークンをレコードに保存します。ブラックリスト。
- AllowList: 有効なトークンをレコードに保存します。ホワイトリスト。

なおこのデモでは、`AllowList`を採用しています。

詳細は下記を参照して下さい。  
https://github.com/waiting-for-dev/devise-jwt#revocation-strategies

### ルーティング

devise-jwtデフォルトのルーティングを利用しています。下記の通りです。
```bash
         new_user_session GET    /users/sign_in(.:format)  devise/sessions#new {:format=>:json}
             user_session POST   /users/sign_in(.:format)  devise/sessions#create {:format=>:json}
     destroy_user_session DELETE /users/sign_out(.:format) devise/sessions#destroy {:format=>:json}
 cancel_user_registration GET    /users/cancel(.:format)   devise/registrations#cancel {:format=>:json}
    new_user_registration GET    /users/sign_up(.:format)  devise/registrations#new {:format=>:json}
   edit_user_registration GET    /users/edit(.:format)     devise/registrations#edit {:format=>:json}
        user_registration PATCH  /users(.:format)          devise/registrations#update {:format=>:json}
                          PUT    /users(.:format)          devise/registrations#update {:format=>:json}
                          DELETE /users(.:format)          devise/registrations#destroy {:format=>:json}
                          POST   /users(.:format)          devise/registrations#create {:format=>:json}
```

ユーザ認証の必要なコントローラへのリクエストには、下記ヘッダを指定します。

```http request
Authorization: Bearer xxx.xxx.xxx（発行されたトークン）
JWT_AUD: クライアント側で発行するデバイス識別記号（UUIDv4とかでもよい）
```
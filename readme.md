#Colorgy API for iOS
前言：因為覺得API爛掉了所以重寫。

### TODO List
1. Travis CI
2. unit testing
3. AFNetworking error handling
4. Refresh Center
5. API Center
6. 要可以知道是哪一種錯誤，還有錯誤的BODY
7. status code 要列舉一下
8. API要某種程度上相依refresh center
9. 需要API時一定要建立一個manager，manager可以做所有的API呼叫，同時也可以在VIEW消失時cancel所有的task。（管理記憶體）


## 規則
success 一定會回傳值

failure 一定會回傳

跟AF有關的一定有

1. error: 代表錯誤的型態，會是列舉
2. `AFError`: optional, 不一定會有，只有在NetworkError時才會出現

每個callback均是optional，所以不一定要傳code block進去



## Class 
### Login
- ColorgyLogin : 拿來做登入用的，裡面有FB登入、Colorgy的兩種登入方法
- ColorgyLoginResult : 可以拿到登入後的結果，例如accesstoken
- ColorgyLoginError : 登入colorgy會出現的錯誤enum
- ColorgyFacebookLoginError : 登入到FB時會發生的錯誤enum

### User Informatoin
- 拿來存 跟user有關的東西
- 任何東西丟給他存就對了

### Refresh Center
- 不跟API有關係
- 但是可以LOCK API的工作





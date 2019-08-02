# WeatherApp

## 구현







## 학습한 내용

## 네트워크

### URL Loading System

> 표준 인터넷 프로토콜을 사용하여 서버와 url 로 소통하는 방식

URL로 확인할 수 있는 리소스에 접근하는 방식을 URL Loading System 이라 한다.

resource loading 은 **asynchronously** (**비동기**) 로 수행되므로, 유저의 이벤트에 응답할 수 있고 들어오는 데이터나 에러를 처리할 수 있다.

#### URLSession 

> Url 로 request 를 보내거나 받는 일을 담당하는 객체

- 설정 : `URLSessionConfiguration`
  - default 
  - ephemeral
  - background
- `URLSession` instance 는 `URLSessionTask` 인스턴스를 한개 이상 생성하여 사용한다. 
  - GET request 통해 데이터를 받아오는 일 : `URLSessionDataTask`
  - POST / PUT request 통해 파일을 업로드 하는 일 : `URLSessionUploadTask`
  - 원격 서버에서 파일을 다운로드 해오는 일 : `URLSessionDownloadTask`
- Task 상태
  - suspend
  - resume
  - cancel
- URLSession 이 데이터를 반환하는 두가지 방법
  1. completion handler - task 가 끝날 때 실행됨
  2. delegate 의 method 호출



#### URLComponents

> URL 을 구성하는 요소들을 구조체로 나타냄

- queryItem property : URLQueryItem (name -value 짝으로 구성되어 URL 의 query 부분을 담당)
- url property : 구성요소들로부터 생성된 URL



### 네트워크

데이터를 URL 로부터 가져오려면 

- 어떤 데이터를 주세요 : request
- 응답 : reponse

#### URLSession 활용한 data GET

```swift
func dataTask(with url: URL, 
completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
```



```swift
let task = URLSession.shared.dataTask(with: url) {
	
}
```



- Data : bytes or nil(error)
- reponse: reponse 의 구현체. HTTPURLReponse 로 타입 캐스팅 가능
- error: error 발생시 값 있음. Nil 이면 성공



- 네트워크 종료시 resume()





### GCD (Grand Central Dispatch)

비동기 수행을 원할 때, main queue(main flow) 말고 다른 수행 queue 로 작업을 보내고 싶을 때 사용

main queue : system 이 제공하는 queue로 모든 UI code 가 수행되어야 하는 곳

```swift
var items: [Item]?

DispatchQueue.main.async {
    items = findItems(matching: "News")
}
// async 클로져가 실행 완료 될 때, item 에 값이 할당 된다.
// 단순히 저 선언문 지나갔다고 실행 완료된게 아님
```

network request 같은 무거운 작업을 할 때는 background queue 에서 실행되는게 앱의 main 에서 실행되는것보다 권장됨. - UI 는 다른 일을 하는 동안 무거운 작업들을 뒤에서 할 수 있으므로



## UICollectionView

> 순서가 있는 데이터 아이템의 모음을 관리하고, 이를 커스터마이징 가능한 레이아웃을 이용해서 보여주는 객체

- data source : collection view 는 UITableView 처럼 data source 객체로부터 data 를 얻어온다. - `UICollectionViewDataSource` protocol 을 채택한 타입
- 각 item 은 cell 을 이용하여 보여진다 - `UICollectionViewCell`
- Data source, cell 은 UITableView 방식과 비슷하다
- 게다가, collection view 는 다른 타입의 view 를 사용해서 data 를 보여줄 수도 있다.
  - section header, footer 
  - cell 과는 분리되어 있으나 여전히 어떤 정보를 전달하는 목적으로 사용됨

### UICollectionViewLayout class

- cell 의 구성과 위치를 담당
- collectionViewLayout property 값으로 설정 가능
  - 값 설정하면 layout 도 즉시 업데이트됨
  - 애니메이션과 함께 업데이트 원하면 setCollectionViewLayout() method 사용

### cell 생성 & view 보충하기

- collection view 의 data source 가 제공하는 두가지
  - Content of items
  - 그 content를 보여주기 위한 views
- cell 가져오기 : dequeueReusableCell(with~)
- 추가 view 가져오기 : dequeReusableSupplementaryView(~)
- nib file 로 cell 등록하기 : register(_: forCellWithReuseIdentifier:)



## UISearchController

> search bar + search result 관리하는 객체

두 개의 view controller 로 구성됨  

- First view : 검색 가능한 content 보여주기 - search controller
  - app 의 main interface 의 한 부분
- second view : search 결과 보여주기 - search result controller

user 가 search bar 와 interaction 하면, search controller 가 자동으로 새로운 vc에 검색 결과를 보여준다.



세가지 구성요소

- searchBar
- searchResultsController
- searchResultsUpdater : search bar text entry 에 응답하는 delegate
  - user 가 search bar 와 interaction 할 때 알림 받는 객체가 searchResultsUpdater
  - `UISearchResultUpdating` protocol
  - 주로 검색할 데이터를 가지고 있는 View Controller 가 updater 가 됨



## Model

first scene 세가지 부분 구성

1. CurrentWeather
2. HourlyWeather list
3. DailyWeather list

|           | CurrentWeather | HourlyWeather | DailyWeather |
| --------- | -------------- | ------------- | ------------ |
| icon      | O              | O             | O            |
| condition | Description    |               |              |
| temp      | current        | Current       | min/max      |
| Date      | 요일           | 시간          | 요일         |

### 설계








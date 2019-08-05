# WeatherApp

## 구현 & 학습한 내용

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



queue 종류 2가지

main : ui 가 처리되는 queue

Global



Serial / concurrent 

Sync / async 

sync : 작업 완료되면 호출자에게 제어권 반환

async : 작업 진행시켜놓고 호출자에게 제어권 반환. 작업은 계속 실행되고 있음. 다음 함수 실행되어 시작하는 스레드를 차단하지 않는다.

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



### 설계 - WeatherPresentable protocol

icon image, tempText, dateText 를 제공하는 자격요건을 명시한 프로토콜을 정의한다.

Current, Hourly, Daily Weather 클래스에서 해당 프로토콜을 채택하여 준수한다



## 검색 구현하기

### MKLocalSearchCompleter

> 문자열로 위치를 제공하면 그에 맞는 자동완성된 comletion string list 를 제공하는 utility 객체

- `results` property : `MKLocalSearchCompleter` 의 자동완성 처리된 데이터를 얻는 속성
  -  `MKLocalSearchCompletion` type
  - 직접 생성할 수는 없다. Completer 에 의해서만 생성되는 객체
- completion 될 대상 지정 방법
  - 위치 문자열, 지역, 필터 타입 등을 지정할 수 있다.
  - 도시명 검색 : `queryFragment` property 에 사용자가 입력하는 문자열 설정
  - 필터 타입 : locationAndQueries / locationsOnly 
- delgate : search completion data 를 가져오기 위한 메소드가 정의됨
  - `MKLocalSearchCompleterDelegate`
  - `completerDidUpdateResults()` 메소드 : completer 가 검색 완성 배열을 업데이트 한 뒤 호출하는 메소드.
  - 이 메소드 안에 search 결과 table view 를 reload 하도록 구현함



## JSON Parsing

### CodingKey

encode/decode 될 때 기준이 되는 key

CodingKey protocol 을 준수한 enumeration 이 있다면, 이 case 들은 codable type 에 encode/decode 될 때, 반드시 포함되어야 하는 속성의 리스트를 나타낸다. 

각 case 이름은 주어질 data type과 맞아야 하는데, 다르다면 String 을 상속받아 associated value 로 지정해주면 된다.

- 참조 - [Encoding & Decoding Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)



### MVVM

Model 과 view controller 사이의 중재자인 view model 을 넣은 디자인 패턴

왜 이 패턴을 사용할까?

- 기존의 mvc, 특히 apple의 mvc 는 massive view controller 라고 불릴만큼 view controller 가 할 일이 많았음. 
- 저장된 model 과 view 를 표현할 때 쓸 model 을 다르게 표현할 필요가 생김
  - 예를들어, 유저 정보를 내부 model 에 가지고 있지만 view model 에서는 일부 정보만 보여준다면? -> controller 가 view 에서 쓸 일부 정보를 가공할 필요가 생김 -> massive view controller 가 될 확률이 높아짐
- loosely coupled architecture -> 변동, 유연한 구조, 테스트에 용이

구조 ([출처](https://medium.com/@navdeepsingh_2336/creating-an-ios-app-with-mvvm-and-rxswift-in-minutes-b8800633d2e8))

![](https://miro.medium.com/max/700/1*iwgAHz3uZGqyk3OhOOjgyg.jpeg)



view model 의 역할

- view update
- View 로부터 받은 update (user 로 부터 받은) update를 처리



two way binding

- Observer-listener 패턴 : view controller - view model 간 양방향 소통을 할 수 있게끔 해줌
- oberserver 패턴은 subject 에 변동이 생기면 알려달라고 미리 observer 등록을 하면, subject 변동시 알람을 받는 패턴이다
- control & data provider



## API 데이터 기반 시간 구하기

- api  의 date & time 정보는 UTC 표준
- `city.timezone` : 해당 도시의 시간을 UTC로부터 변환하기 위한 차이값. 단위는 초
- `list.dt_txt` : UTC 시간
- 각 도시의 시간 = `list.dt_txt` 를 date로 변환한 객체 + `city.timezone`
- 구현 방법 : `Date` - `addingTimeInterval()` method 사용



## UserDefaults

앱의 data 를 백그라운드 상태 혹은 종료시에도 없어지지 않고 persistent(영구) 보존할 수 있도록 해주는 user default database

- key-value 형태로 저장된다. Key 는 String 만 가능
- 저장 가능한 Value 형태 : NSData, NSString, NSNumber, NSArray, NSDictionary
- 특성
  - UserDefaults 통해 가져온 데이터는 immutable 
  - plist extension 으로 저장됨
  - app launch 될 때, memory 에 올라온다. 
- UserDefaults 변경에 알림을 받고 싶다면
  - didChangeNotification 에 observer 를 등록하면 된다.








## 🍾 Wurisool

<img src = "https://github.com/Neph3779/WuriSool/assets/67148595/2449b4c1-bd18-4c42-a71b-05ebe344ed80" width = "50%" height = "50%">

| <img width="810" alt="image" src="https://github.com/Neph3779/WuriSool/assets/67148595/0a06c5bf-038f-4778-9adc-0877e13b5727"> | <img width="810" alt="image" src="https://github.com/Neph3779/WuriSool/assets/67148595/94f85431-efe9-4d14-b3d4-374c8e129e76"> | <img width="810" alt="image" src="https://github.com/Neph3779/WuriSool/assets/67148595/b1445e90-b772-4894-8ead-256584d58e4b"> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |



**작업기간: 2023/02 ~ 2023/06 (약 4개월)**

**프로젝트 소개 영상: [우리술 프로젝트 소개영상](https://www.youtube.com/watch?v=4MA8vv-kqu8&ab_channel=2023%ED%99%8D%EC%9D%B5%EB%8C%80%EC%BB%B4%EA%B3%B5%EC%A1%B8%EC%97%85%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8)**



### App의 구조와 특징

<img src = "https://github.com/Neph3779/WuriSool/blob/main/graph.png">

- 각 탭을 모듈로 분리하였습니다.
  - 해당 탭만 구동할 수 있는 demoApp 실행환경을 제작하였습니다.
- 공통 로직 모듈 분리
  - BaseDomain, Network, Core 모듈을 분리하여 의존성 없이 다른 모듈에서 import하여 사용할 수 있도록 하였습니다.
- Clean-Architecture 적용
  - 탭별 모듈의 내부는 Clean-Architecture 패턴이 적용되어 있습니다.
    - Domain, Data, Presentation을 각각의 모듈로 분리해 Domain 레이어가 다른 레이어에 의존관계를 가지지 않도록 의존관계를 설정해주었습니다.
    - 만약 잘못된 의존방향이 설정되는 경우, 컴파일 단계에서 이를 인지할 수 있습니다.



### 사용 라이브러리

- Alamofire
- RxSwift
- SnapKit
- Kingfisher
- Toast

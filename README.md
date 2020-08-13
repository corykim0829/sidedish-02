<h1 align="center">
  온라인 반찬 서비스
</h1>
<p align="center">

<p align="center">
 <img src="https://img.shields.io/badge/platform-iOS-9cf.svg">
 <p align="center">배민찬 서비스 일부를 똑같이 만들어 보는 프로젝트</p>
</p>

<p align="center">
<img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-1.png" width="200px"> <img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-2.png" width="200px"> <img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-3.png" width="200px"> <img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-4.png" width="200px"> <img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-5.png" width="200px"> <img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-6.png" width="200px"><img src="https://github.com/corykim0829/sidedish-02/blob/dev/screenshots/screenshot-7.png" width="200px">
</p>
<br>

#### 디스크 캐싱 구현

이미지를 매번 요청하여 상품 이미지를 업데이트하는 비용을 줄이기 위해서 디스크 캐싱을 구현하였습니다. 테이블 뷰의 반찬 목록의 썸네일 이미지와, 상세화면 이미지들을 디스크 캐싱하였습니다.

FileManager를 통해 이미지를 저장 후 

`NetworkManager`의 `fetchImage` 메소드

```swift
func fetchImage(from: String, cachedImageFileURL: URL? = nil, completion: @escaping (Result<Data, NetworkErrorCase>) -> Void) {
    
    let URLRequest = URL(string: from)!
    
    URLSession.shared.downloadTask(with: URLRequest) { (url, _, error) in
        if error != nil { completion(.failure(.InvalidURL)) }
        guard let url = url else { completion(.failure(.InvalidURL)); return }
        guard let data = try? Data(contentsOf: url) else { completion(.failure(.InvalidURL)); return }
        
        // temp url의 data를 cachedImageFileURL에 저장
        if let cachedImageFileURL = cachedImageFileURL {
            try? FileManager.default.moveItem(at: url, to: cachedImageFileURL)
        }
        
        completion(.success(data))
    }.resume()
}
```

<br>

테이블뷰의 DataSource에서 디스크 캐시된 이미지가 있으면 그 이미지를 바로 업데이트하게 하였고, 없으면 다시 요청하여 이미지를 업데이트 하도록 구현하였습니다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
    let product = productsList[indexPath.section][indexPath.row]
    
    let url = URL(string: product.imageURL)!
    let cachedImageFileURL = try! FileManager.default
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(url.lastPathComponent)
    
    if let cachedData = try? Data(contentsOf: cachedImageFileURL) {
        let image = UIImage(data: cachedData)
        cell.configureProductImage(image)
    } else {
        networkManager.fetchImage(from: product.imageURL, cachedImageFileURL: cachedImageFileURL) { (result) in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.configureProductImage(image)
                }
            case .failure(_):
                break
            }
        }
    }
    
    cell.configureProductCell(with: product)
    return cell
}
```

<br>

### TEAM

Back-end
- David 😈
- Ragdoll 🐱

Front-end

- Sally 🐤

iOS

- Cory 🦊

<br>

### 기능 명세서
- [구글 스프레드 시트](https://docs.google.com/spreadsheets/d/1i2-zwmvJfrWQgxuAaOkxmDapg4j7IVDe1kdvXKVM87w/edit#gid=0)

<br>
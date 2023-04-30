import Alamofire
import RealmSwift

protocol CharactersCollectionViewModel: AnyObject {
    var onChangeViewState: ((CharactersCollectionViewController.State) -> Void)? { get set }
    func start()
    func getCharacters() -> [CharactersCollectionViewController.Model]
    func onPullToRefresh()
}

final class CharactersCollectionViewModelImpl: CharactersCollectionViewModel{
    var onChangeViewState: ((CharactersCollectionViewController.State) -> Void)?
    
    func start() {
        fetchCharacters()
    }
    
    func getCharacters() -> [CharactersCollectionViewController.Model] {
        self.characters
    }
    
    func onPullToRefresh() {
        fetchCharacters()
    }
    
    private var characters: [CharactersCollectionViewController.Model]
    private var repository: CharactersRepository
    private var offset: Int
    
    init(repository: CharactersRepository) {
        self.repository = repository
        self.characters = []
        self.offset = 0
    }
    private func fetchCharacters() {
        onChangeViewState?(.loading)
        repository.fetchCharacters(offset: offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moreCharacters):
                self.characters += moreCharacters
                self.offset += moreCharacters.count
                self.onChangeViewState?(.loaded(self.characters))
                print(self.characters.count)
            case .failure(let error as CharactersRepositoryImpl.MyCustomError):
                switch error {
                case .offlineData(let savedCharacters):
                    self.characters += savedCharacters
                    self.onChangeViewState?(.loaded(self.characters))
                }
            case .failure(_):
                break
            }
        }
    }
}

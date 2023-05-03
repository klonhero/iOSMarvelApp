import Alamofire
import RealmSwift

protocol CharactersCollectionViewModel: AnyObject {
    var onChangeViewState: ((CharactersCollectionViewController.State) -> Void)? { get set }
    func start()
    func onPullToRefresh()
    func onCellDeque(at index: Int) -> CharactersCollectionViewController.Model
    func onCharacterCellTapped(at index: Int)
    func onChangingTriangleColor(at index: Int) -> CharactersCollectionViewController.Model
    func onDeceleratingEnd(at index: Int)
    func charactersCount() -> Int
}

final class CharactersCollectionViewModelImpl: CharactersCollectionViewModel{
    
    private var characters: [CharactersCollectionViewController.Model]
    private var repository: CharactersRepository
    private var offset: Int
    
    init(repository: CharactersRepository) {
        self.repository = repository
        self.characters = []
        self.offset = 0
    }
    
    var onChangeViewState: ((CharactersCollectionViewController.State) -> Void)?
    
    func start() {
        fetchCharacters()
    }
    
    func onPullToRefresh() {
        fetchCharacters()
    }
    
    func onCellDeque(at index: Int) -> CharactersCollectionViewController.Model {
        return characters[index]
    }
    
    func onCharacterCellTapped(at index: Int){
        onChangeViewState?(.showDescriptionScreen(characters[index]))
    }
    
    func onChangingTriangleColor(at index: Int) -> CharactersCollectionViewController.Model {
        return characters[index]
    }
    func onDeceleratingEnd(at index: Int) {
        onChangeViewState?(.changeTriangleColor(characters[index]))
    }
    func charactersCount() -> Int {
        return characters.count
    }
    
    private func fetchCharacters() {
        onChangeViewState?(.loading)
        repository.fetchCharacters(offset: offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moreCharacters):
                self.characters += moreCharacters
                self.offset += moreCharacters.count
                self.onChangeViewState?(.loaded)
                print(self.characters.count)
            case .failure(let error as CharactersRepositoryImpl.MyCustomError):
                switch error {
                case .offlineCharacters(let savedCharacters):
                    self.characters += savedCharacters
                    self.onChangeViewState?(.loaded)

                case .offlineCharacter(_):
                    break
                }
        
            case .failure(_):
                self.onChangeViewState?(.connectionError)
            }
        }
    }
}

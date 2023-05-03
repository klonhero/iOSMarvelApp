protocol DescriptionViewModel: AnyObject {
    var onChangeViewState: ((DescriptionViewController.State) -> Void)? { get set }
    func start(with id: Int)
}

final class DescriptionViewModelImpl: DescriptionViewModel {
    private let repository = CharactersRepositoryImpl()
    var onChangeViewState: ((DescriptionViewController.State) -> Void)?
    
    func start(with id: Int) {
        fetchCharacter(by: id)
    }
    
    private func fetchCharacter(by id: Int) {
        repository.fetchCharacter(by: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let character):
                guard let character = character else {
                    return
                }
                self.onChangeViewState?(.loaded(character))
            case .failure(let error as CharactersRepositoryImpl.MyCustomError):
                switch error {
                case .offlineCharacter(let savedCharacter):
                    guard let character = savedCharacter else {
                        return
                    }
                    self.onChangeViewState?(.loaded(character))
                case .offlineCharacters(_):
                    break
                }
        
            case .failure(_):
                break
            }
        }
    }
}

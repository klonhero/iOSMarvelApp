import UIKit
import CollectionViewPagingLayout
import Kingfisher

final class CharactersCollectionViewController: UIViewController {
    
    enum State {
        case loading
        case loaded([Model])
        case connectionError
    }
    
    struct Model {
        let name: String
        let description: String
        let imageURL: String
    }

    private var viewModel: CharactersCollectionViewModel
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    init(viewModel: CharactersCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let activityIndicatorView: ActivityIndicatorView = {
        let activityIndicatorView = ActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.backgroundColor = .black
        activityIndicatorView.isUserInteractionEnabled = false
        return activityIndicatorView
    }()
    
    private let connectionErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No connection, try again later"
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let triangleView: TriangleView = {
        let pathView = TriangleView()
        pathView.translatesAutoresizingMaskIntoConstraints = false
        pathView.backgroundColor = .clear
        return pathView
    }()
    

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "marvelLogo")
        return imageView
    }()
    
    private let descriptionViewController = DescriptionViewController()
    
    private let collectionViewLayout: CollectionViewPagingLayout = {
        let layout = CollectionViewPagingLayout()
        layout.setCurrentPage(0)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "UnderLogoTextColor")
        label.text = "Choose your hero"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        viewModel.onChangeViewState = {[weak self] state in
            switch state {
            case .loading:
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.connectionErrorLabel.alpha = 0
                }
                self?.activityIndicatorView.start()
            case .loaded(_):
                self?.collectionView.reloadData()
                self?.activityIndicatorView.stop()
            case .connectionError:
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.connectionErrorLabel.alpha = 1
                }
            }
        }
        viewModel.start()
        setupViewLayout()
    }

    private func setupViewLayout() {
        view.addSubview(triangleView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(connectionErrorLabel)
        view.addSubview(activityIndicatorView)
        setupConstraintsTriangle()
        setupConstraintsMarvelLogo()
        setupConstraintsLabel()
        setupConstraintsHeroesCollection()
        setupConstraintsLoadingView()
        setupConstraintsConnectionLabel()
    }

    private func setupConstraintsConnectionLabel() {
        NSLayoutConstraint.activate([
            connectionErrorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            connectionErrorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            connectionErrorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            connectionErrorLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupConstraintsTriangle() {
        NSLayoutConstraint.activate([
            triangleView.topAnchor.constraint(equalTo: view.topAnchor),
            triangleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            triangleView.leftAnchor.constraint(equalTo: view.leftAnchor),
            triangleView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupConstraintsMarvelLogo() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 25),
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }

    private func setupConstraintsLabel() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 75),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupConstraintsHeroesCollection() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupConstraintsLoadingView() {
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            activityIndicatorView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension CharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCharacters().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCollectionViewCell.self), for: indexPath)
        guard let cell = cell as? CharacterCollectionViewCell else {
            return cell
        }
        let hero = viewModel.getCharacters()[indexPath.item]
        cell.setupCell(model: CharacterCollectionViewCell.Model(name: hero.name, url: URL(string: hero.imageURL)))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = viewModel.getCharacters()[indexPath.item]
        let model = DescriptionViewController.Model(url: URL(string: hero.imageURL), name: hero.name, description: hero.description)
        descriptionViewController.setup(model)
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = findCenterIndex()
        guard let index = index else { return }
        changeTriangleColor(character: viewModel.getCharacters()[index.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x - scrollView.contentSize.width) > CGFloat(-350) {
            viewModel.onPullToRefresh()
            collectionViewLayout.setCurrentPage(viewModel.getCharacters().count)
        }
    }

    private func findCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }
    private func changeTriangleColor(character: Model) {
        guard let url: URL = URL(string: character.imageURL) else {
            return
        }
        let imageResource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: imageResource, options: nil, progressBlock: nil, completionHandler: {
            result in
            switch result {
            case .success(let result):
                self.triangleView.color = result.image.averageColor
            case .failure(_):
                self.triangleView.color = .clear
            }
        })
    }
}

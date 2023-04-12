import UIKit
import CollectionViewPagingLayout

final class HeroListViewController: UIViewController {

    private var lastCenterIndex: IndexPath? = nil
    
    private let viewModel = HeroListViewModel()
    
    private var listHeroData = [HeroData]()
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .clear
        loadingView.isUserInteractionEnabled = false
        return loadingView
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
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HeroCollectionViewCell.self))
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
        viewModel.fetchHeroes(compleation: { [weak self] items in
            self?.listHeroData = items
            self?.collectionView.reloadData()
            self?.collectionViewLayout.setCurrentPage(0)
            self?.loadingView.stop()
        })
        setupViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.start()
    }

    private func setupViewLayout() {
        view.addSubview(triangleView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        setupTriangle()
        setupMarvelLogo()
        setupLabel()
        setupHeroesCollection()
        setupLoadingView()
    }

    private func setupTriangle() {
        NSLayoutConstraint.activate([
            triangleView.topAnchor.constraint(equalTo: view.topAnchor),
            triangleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            triangleView.leftAnchor.constraint(equalTo: view.leftAnchor),
            triangleView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupMarvelLogo() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 25),
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }

    private func setupLabel() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 75),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupHeroesCollection() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupLoadingView() {
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension HeroListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listHeroData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroCollectionViewCell.self), for: indexPath) as? HeroCollectionViewCell else {
            return HeroCollectionViewCell()
        }
        let hero = listHeroData[indexPath.item]
        cell.setupCell(model: HeroCollectionViewCell.Model(name: hero.name, url: URL(string: hero.imageURL) ))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = listHeroData[indexPath.item]
        let model = DescriptionViewController.Model(url: URL(string: hero.imageURL), name: hero.name, description: hero.description)
        descriptionViewController.setup(model)
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard findCenterIndex() == lastCenterIndex else {
            return
        }
        lastCenterIndex = findCenterIndex()
        guard let lastCenterIndex = lastCenterIndex else {
            return
        }
        let cell = collectionView.cellForItem(at: lastCenterIndex) as? HeroCollectionViewCell
        guard let cell = cell else {
            return
        }
        triangleView.color = cell.imageAverageColor
    }

    private func findCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }
}

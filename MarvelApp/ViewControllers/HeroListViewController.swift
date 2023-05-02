import UIKit
import CollectionViewPagingLayout

final class HeroListViewController: UIViewController {

    private var lastCenterIndexPath: IndexPath? = nil
    
    private let viewModel = HeroListViewModel()
    
    private var heroesData = [HeroData]()
    
    private var isLoadingMore = false
    
    private let activityIndicatorView: ActivityIndicatorView = {
        let activityIndicatorView = ActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.backgroundColor = .black
        activityIndicatorView.isUserInteractionEnabled = false
        return activityIndicatorView
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
        activityIndicatorView.start()
        isLoadingMore = true
        viewModel.fetchHeroes(
            compleation: { [weak self] newHeroesData, offset in
                self?.isLoadingMore = false
                self?.heroesData.append(contentsOf: newHeroesData)
                self?.collectionView.reloadData()
                self?.collectionViewLayout.setCurrentPage(offset)
                self?.activityIndicatorView.stop()
            },
            failed: {
                print("failed to fetch data")
            }
        )
        setupViewLayout()
    }

    private func setupViewLayout() {
        view.addSubview(triangleView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
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
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            activityIndicatorView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension HeroListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        heroesData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroCollectionViewCell.self), for: indexPath) as? HeroCollectionViewCell else {
            return HeroCollectionViewCell()
        }
        let hero = heroesData[indexPath.item]
        cell.setupCell(model: HeroCollectionViewCell.Model(name: hero.name, url: URL(string: hero.imageURL)))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = heroesData[indexPath.item]
        let model = DescriptionViewController.Model(url: URL(string: hero.imageURL), name: hero.name, description: hero.description)
        descriptionViewController.setup(model)
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard findCenterIndexPath() == lastCenterIndexPath else {
            return
        }
        lastCenterIndexPath = findCenterIndexPath()
        guard let lastCenterIndex = lastCenterIndexPath else {
            return
        }
        let cell = collectionView.cellForItem(at: lastCenterIndex) as? HeroCollectionViewCell
        guard let cell = cell else {
            return
        }
        triangleView.color = cell.imageAverageColor
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x - scrollView.contentSize.width) > CGFloat(-420) && !isLoadingMore {
            isLoadingMore = true
            viewModel.fetchHeroes(
                compleation: { [weak self] newHeroesData, offset in
                    self?.heroesData.append(contentsOf: newHeroesData)
                    self?.collectionView.reloadData()
                    self?.collectionViewLayout.setCurrentPage(offset - 1)
                    self?.isLoadingMore = false
                },
                failed: { [weak self] in
                    self?.isLoadingMore = false
                }
            )
        }
    }

    private func findCenterIndexPath() -> IndexPath? {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }
}

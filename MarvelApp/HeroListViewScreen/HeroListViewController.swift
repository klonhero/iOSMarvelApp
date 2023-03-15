import UIKit
import CollectionViewPagingLayout

final class HeroListViewController: UIViewController {

    private var lastCenterIndex: Int = 0
    
    private let viewModel = HeroListViewModel()
    
    private var listHeroData = [HeroData]()
    
    private let pathView: PathView = {
        let pathView = PathView()
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        setupViewLayout()
        setupPath()
        setupMarvelLogo()
        setupUnderLogoText()
        setupHeroesCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchListData(compleation: { [weak self] items in
            self?.listHeroData = items
            self?.collectionView.reloadData()
        })
    }

    private func setupViewLayout() {
        view.addSubview(pathView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(collectionView)
    }

    private func setupPath() {
        NSLayoutConstraint.activate([
            pathView.topAnchor.constraint(equalTo: view.topAnchor),
            pathView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pathView.rightAnchor.constraint(equalTo: view.rightAnchor)
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

    private func setupUnderLogoText() {
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
        cell.setupCell(model: HeroCollectionViewCell.Model(name: hero.name, url: URL(string: hero.url)! ))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = listHeroData[indexPath.item]
        let image = UIImage(named: hero.asset)!
        let model = DescriptionViewController.Model(image: image, name: hero.name, description: hero.description)
        descriptionViewController.setup(model)
        navigationController?.pushViewController(descriptionViewController, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerIndex = findCenterIndex()
        let color = (UIImage(named: listHeroData[centerIndex].asset)?.averageColor!.withAlphaComponent(1))!
        pathView.color = color.lighter(by: 25)!
    }

    private func findCenterIndex() -> Int {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        lastCenterIndex = index?.item ?? lastCenterIndex
        return lastCenterIndex
    }

}

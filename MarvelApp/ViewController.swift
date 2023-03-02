import UIKit
import CollectionViewPagingLayout

class ViewController: UIViewController {
    
    private var lastCenterIndex = 0
    private var pathView: PathView = {
        let pathView = PathView()
        pathView.translatesAutoresizingMaskIntoConstraints = false
        pathView.backgroundColor = .clear
        pathView.color = UIColor(named: listHeroData[0].color)!
        return pathView
    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "marvelLogo")
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: String(describing: HeroCell.self))
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
        super.loadView()
        view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupViewLayout()
        setupPath()
        setupMarvelLogo()
        setupUnderLogoText()
        setupHeroesCollection()
    }

    private func setupViewLayout() {
        view.addSubview(pathView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(collectionView)
    }
    
    private func setupPath() {
        NSLayoutConstraint.activate([
            pathView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pathView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pathView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    private func setupMarvelLogo() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 25)
            ])
    }
    //TODO: Убрать константные ширину и высоту заменить на левый и правый constraint
    
    
    private func setupUnderLogoText() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 400),
            label.heightAnchor.constraint(equalToConstant: 75)
            ])
    }
    //TODO: Убрать константные ширину и высоту заменить на левый и правый constraint
    
    private func setupHeroesCollection() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listHeroData.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroCell.self), for: indexPath) as! HeroCell
        
        let hero = listHeroData[indexPath.item]
        cell.setupCell(model: HeroCellModel(name: hero.name, image: UIImage(named: hero.asset)!))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerIndex = findCenterIndex()
        pathView.color = UIColor(named: listHeroData[centerIndex].color)!
    }
    
    private func findCenterIndex() -> Int {
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        lastCenterIndex = index?.item ?? lastCenterIndex
        return lastCenterIndex
    }

}

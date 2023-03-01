import UIKit
import CollectionViewPagingLayout

class ViewController: UIViewController{
    
    lazy var pathView: PathView = {
        let pathView = PathView()
        pathView.translatesAutoresizingMaskIntoConstraints = false
        pathView.backgroundColor = .clear
        return pathView
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "marvelLogo")
        return imageView
    }()
    
    lazy var heroesCollectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        return collectionView
    }()
    
    var underLogoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor(named: "UnderLogoTextColor")
        textView.text = "Choose your hero"
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupViewLayout()
        setupPath()
        setupMarvelLogo()
        setupUnderLogoText()
        setupHeroesCollection()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        path.addLine(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY))
        path.addLine(to: CGPoint(x: view.frame.maxX, y: view.frame.midY))
        path.addLine(to: CGPoint(x: view.frame.minX, y: view.frame.minY))
        path.close()
        path.lineWidth = 3
        pathView.path = path
    }
    

    private func setupViewLayout() {
        view.addSubview(pathView)
        view.addSubview(logoImageView)
        view.addSubview(underLogoTextView)
        view.addSubview(heroesCollectionView)
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
    
    private func setupUnderLogoText() {
        NSLayoutConstraint.activate([
            underLogoTextView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            underLogoTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            underLogoTextView.widthAnchor.constraint(equalToConstant: 400),
            underLogoTextView.heightAnchor.constraint(equalToConstant: 75)
            ])
    }
    
    
    private func setupHeroesCollection() {
        NSLayoutConstraint.activate([
            heroesCollectionView.topAnchor.constraint(equalTo: underLogoTextView.bottomAnchor),
            heroesCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            heroesCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            heroesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listHeroData.count
        } 
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: Убрать UIImageView и UITextView внутрь cell, вместо этого сделать модель HeroCellModel и через нее прокидывать нужную инфу (картинку, имя и т.д.)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        

        lazy var view: UIView = {
            let view = UIView(frame: CGRect(x: cell.frame.minX + 20, y: cell.frame.minY + 30, width: cell.frame.width - 40, height: cell.frame.height - 60))
            view.backgroundColor = .black.withAlphaComponent(0.4)
            view.layer.cornerRadius = 20
            return view
        }()
        
        
        let hero = listHeroData[indexPath.item]
//        if collectionView.indexPathsForVisibleItems.isEmpty {
//            pathView.backgroundColor = .clear
//        } else {
//            pathView.backgroundColor = UIColor(named: listHeroData[collectionView.indexPathsForVisibleItems.first!.item].color)!
//        }
        lazy var heroImageView: UIImageView = {
            let imageView = UIImageView(frame: cell.frame)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: hero.asset)
            imageView.contentMode = .scaleToFill
            return imageView
        }()

        
        lazy var nameTextView: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = .clear
            textView.text = hero.name
            textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail //to add ... at the end of too long text
            textView.textContainer.maximumNumberOfLines = 1
            textView.textColor = .white
            textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            return textView
        }()
        
        view.addSubview(heroImageView)
        view.addSubview(nameTextView)
        cell.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            nameTextView.heightAnchor.constraint(equalToConstant: 60),
            nameTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            nameTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            heroImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            heroImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            heroImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)
        ])
        return cell
       }
}

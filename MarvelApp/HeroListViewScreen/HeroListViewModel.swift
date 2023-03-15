import Foundation

final class HeroListViewModel {
    
    func fetchListData(compleation: ([HeroData]) -> Void) {
        //TODO: download data elems
        compleation(listHeroData)
    }
    
    private let listHeroData: [HeroData] = [
        HeroData(asset: "CaptainAmerica", name: "Captain America", color: "CaptainAmerica", description: "This is Captain America", url: "https://freepngimg.com/thumb/captain_america/7-2-captain-america-png-hd.png"),
        HeroData(asset: "IronMan", name: "Iron Man", color: "IronMan", description: "This is Iron Man", url: "https://i.pinimg.com/originals/c1/4a/9f/c14a9f2295038c162b7b076c28c06af7.png"),
        HeroData(asset: "Deadpool", name: "Deadpool", color: "Deadpool", description: "This is Deadpool", url: "https://www.pngall.com/wp-content/uploads/2016/03/Deadpool-PNG.png"),
        HeroData(asset: "DoctorStrange", name: "Doctor Strange", color: "DoctorStrange", description: "This is Doctor Strange", url: "https://www.pngall.com/wp-content/uploads/11/Marvel-Doctor-Strange.png"),
        HeroData(asset: "Thor", name: "Thor", color: "Thor", description: "This is Thor weqwdsacasdasdwqe weqwdqwuhewiufhuyewgvyuiewqgyfgqewyucgeuwyqcgewqgcuyewgqcyugq equwygcyuegwqycugewyqucgequwycyueqwgcyugwyuegwquycgequwycgyequwcuegqwycugequwycguyeqwe13kdlajioduasud21u3poj12j oidhiuo1 youdyo1ihdio h12oi hdio12 hdh2io1 hdoh12jiu atdy g1iuk hj12hi hu1 khu2i1 12hiu hsaud 13", url: "https://i.pinimg.com/originals/fc/31/85/fc318551acc519108d011018a0a33421.png")]
}

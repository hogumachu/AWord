import RxDataSources

struct WordSet: Equatable, IdentifiableType {
    var identity: String
    
    typealias Identity = String
    
    var title: String
    var sectionModel: WordSectionModel
    
    init(title: String, sectionModel: WordSectionModel) {
        self.title = title
        self.sectionModel = sectionModel
        self.identity = title
    }
}

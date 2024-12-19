//
//  PlayerController.swift
//  TheMovieApp
//
//  Created by evhn on 19.12.2024.
//

import UIKit

class PlayerController: BaseViewController {
    var trailerurl:String
    
    
    init(trailerurl: String) {
        self.trailerurl = trailerurl
        super.init(nibName: nil,bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MoreMenuAdapter.swift
//  Shadhin-BL
//
//  Created by Joy on 26/9/22.
//

import UIKit
import SwiftEntryKit

protocol MoreMenuAdapterProtocol{
    func onItemPressed(item : MoreMenuModel,at : Int)
}

class MoreMenuAdapter : NSObject{
    private var dataSource : [MoreMenuModel]
    private var delegate : MoreMenuAdapterProtocol
    
    init(dataSource: [MoreMenuModel], delegate: MoreMenuAdapterProtocol) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    func setDataSource(with data : [MoreMenuModel]){
        self.dataSource = data
    }
}
extension MoreMenuAdapter: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else{
            fatalError()
        }
        cell.bind(with : dataSource[indexPath.row])
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SwiftEntryKit.dismiss {[weak self] in
            guard let self = self else {return}
            self.delegate.onItemPressed(item: self.dataSource[indexPath.row], at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36 + 16
    }
}

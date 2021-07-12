//
//  ViewController.swift
//  ArtistDemo
//

import UIKit

//MARK:- Artist tableview cell
class ArtistCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lblTrackPrice: UILabel!
    @IBOutlet weak var lblPrimaryGenreName: UILabel!

    //MARK:- Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTrackPrice.textColor = UIColor.systemBlue
        
        viewPrice.layer.cornerRadius = 5.0
        viewPrice.layer.borderWidth = 1.0
        viewPrice.layer.borderColor = UIColor.systemBlue.cgColor
        viewPrice.clipsToBounds = true
    }
    
    //MARK:- Bind data
    func bindData(objArtist: ArtistModel) {
        lblArtistName.text = objArtist.artistName ?? "-"
        lblTrackName.text = objArtist.trackName ?? "-"
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        if let date = dateformatter.date(from: objArtist.releaseDate ?? "") {
            dateformatter.dateFormat = "d MMM, YYYY"
            let strDate = dateformatter.string(from: date)
            lblReleaseDate.text = strDate
        }
        
        lblTrackPrice.text = (objArtist.currency ?? "") + " " + "\(objArtist.trackPrice ?? 0.0)"
        lblPrimaryGenreName.text = objArtist.primaryGenreName ?? "-"
    }
}

//MARK:- View controller
class ViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblArtist: UITableView!
    
    //MARK:- Variables
    let artistViewModel = ArtistViewModel()
    let activityIndicator = UIActivityIndicatorView.init(style: .medium)
    
    //MARK:- Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }

    func initialization() {
        
        self.view.backgroundColor = .white
        self.title = "Artist"
        
        tblArtist.tableFooterView = UIView()
        tblArtist.delegate = self
        tblArtist.dataSource = self
        
        txtSearch.delegate = self

        fetchArtist(isInitial: true)
    }

    //MARK:- Fetch artists data
    func fetchArtist(isInitial: Bool = false) {
        
        artistViewModel.arrArtist.removeAll()
        tblArtist.reloadData()
        
        activityIndicator.startAnimating()
        tblArtist.backgroundView = activityIndicator
        
        artistViewModel.fetchData { [weak self] (status) in
            
            self?.activityIndicator.stopAnimating()
            self?.tblArtist.backgroundView = nil

            if !isInitial {
                if self?.artistViewModel.arrArtist.count == 0 {
                    let lblNoArtist = UILabel()
                    lblNoArtist.text = "No artist found"
                    lblNoArtist.textColor = .lightGray
                    lblNoArtist.font = UIFont.italicSystemFont(ofSize: 15.0)
                    lblNoArtist.textAlignment = .center
                    self?.tblArtist.backgroundView = lblNoArtist
                }
            }
            self?.tblArtist.reloadData()
        }
    }
    
    //MARK:- Search action
    @IBAction func btnSearchTapped(_ sender: Any) {
        self.view.endEditing(true)
        let str = txtSearch.text ?? ""
        artistViewModel.text = str
        fetchArtist()
    }
}

//MARK:- Tableview delegate & data-source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistViewModel.arrArtist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        cell.bindData(objArtist: artistViewModel.arrArtist[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK:- Textfield delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let str = textField.text ?? ""
        artistViewModel.text = str
        fetchArtist()
        return true
    }
}

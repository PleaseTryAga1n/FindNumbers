import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var nextDigitLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startNewGameButton: UIButton!
    
    // MARK: - Methods
    lazy var game = Game(countItems: numberButtons.count) { [weak self] (status,time) in
        guard let self = self else {return}
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
        
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = numberButtons.firstIndex(of: sender) else {return}
        game.check(index: buttonIndex)
        updateUI()
        
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.alpha = 0
        setupScreen()
    }
    
    
    private func setupScreen(){
        
        for i in game.items.indices{
            numberButtons[i].setTitle(game.items[i].title, for: .normal)
            
            numberButtons[i].alpha = game.items[i].isFound ?0:1
            
            numberButtons[i].isEnabled = !game.items[i].isFound
            
        }
        
        nextDigitLabel.text = game.nextItem?.title
    }
    
    private func updateUI(){
        for i in game.items.indices{
            
            numberButtons[i].alpha = game.items[i].isFound ?0:1
            
            numberButtons[i].isEnabled = !game.items[i].isFound
            
            
            if game.items[i].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.numberButtons[i].backgroundColor = .red
                }   completion: { [weak self](_) in
                    self?.numberButtons[i].backgroundColor = .white
                    self?.game.items[i].isError = false
                }
            }
        }
        nextDigitLabel.text = game.nextItem?.title
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame){
        switch status {
        case .start:
            statusLabel.text = "Game started!"
            statusLabel.textColor = .black
            startNewGameButton.isHidden = true
        case .win:
            statusLabel.text = "You won the game!"
            statusLabel.textColor = .green
            startNewGameButton.isHidden = false
            if game.isNewRecord{
                showAlert()
            }
            else{
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "Game failed!"
            statusLabel.textColor = .red
            startNewGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Congratulations!", message: "You've set a new Record!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertActionSheet(){
        let alert = UIAlertController(title: "What would like to do next?", message: nil,
                                      preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Start new game", style: .default){ [weak self](_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        
        let showRecordAction = UIAlertAction(title: "See the Record", style: .default){ [weak self](_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
            
        }
        
        let menuAction = UIAlertAction(title: "Back to Menu", style: .destructive){ [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecordAction)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true)
    }
    
}
